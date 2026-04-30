#!/bin/bash
# JSON wrapper — uses jq when available, falls back to Node.js >= 18.
# Detect once at load time; callers use _json_* functions.

if command -v jq > /dev/null 2>&1; then
  _JSON_CMD="jq"
else
  _JSON_CMD="node"
fi

# Read a single field from a JSON file.
# Usage: _json_read FILE DOTPATH  (e.g. _json_read pkg.json '.version')
_json_read() {
  local file="$1" path="$2"
  if [ "$_JSON_CMD" = "jq" ]; then
    jq -r "${path} // empty" "$file" 2> /dev/null
  else
    local keys
    keys=$(echo "$path" | sed 's/^\.//' | tr '.' ' ')
    node - "$file" "$keys" << 'NODESCRIPT' 2> /dev/null
      try {
        let d = JSON.parse(require('fs').readFileSync(process.argv[2],'utf8'));
        for (const k of process.argv[3].split(' ').filter(Boolean)) d = d?.[k];
        if (d != null) process.stdout.write(String(d));
      } catch(e) {}
NODESCRIPT
  fi
}

# Validate that a file contains valid JSON. Returns 0 if valid, 1 otherwise.
_json_valid() {
  local file="$1"
  if [ "$_JSON_CMD" = "jq" ]; then
    jq -e . "$file" > /dev/null 2>&1
  else
    node - "$file" << 'NODESCRIPT' 2> /dev/null
      try{JSON.parse(require('fs').readFileSync(process.argv[2],'utf8'));process.exit(0);}
      catch(e){process.exit(1);}
NODESCRIPT
  fi
}

# Deep-merge a JSON object into a file. Overwrites file with merged result.
# Usage: _json_merge TARGET_FILE MERGE_JSON_STRING
_json_merge() {
  local target="$1" merge="$2" tmp
  tmp=$(mktemp)
  if [ "$_JSON_CMD" = "jq" ]; then
    jq --argjson m "$merge" '. * $m' "$target" > "$tmp" && mv "$tmp" "$target" || rm -f "$tmp"
  else
    node - "$target" "$merge" << 'NODESCRIPT' 2> /dev/null || return 1
      const fs=require('fs');
      const target=process.argv[2], merge=JSON.parse(process.argv[3]);
      const deep=(a,b)=>typeof b!=='object'||Array.isArray(b)?b:Object.fromEntries(
        [...new Set([...Object.keys(a||{}),...Object.keys(b)])].map(k=>[k,k in b?
        (typeof b[k]==='object'&&!Array.isArray(b[k])&&k in (a||{})?deep(a[k],b[k]):b[k]):a[k]]));
      fs.writeFileSync(target,JSON.stringify(deep(JSON.parse(fs.readFileSync(target,'utf8')),merge),null,2));
NODESCRIPT
    rm -f "$tmp"
  fi
}

# Build the initial .ai-setup.json structure.
# Usage: _json_build_metadata VER INST_TIME UPD_TIME
_json_build_metadata() {
  local ver="$1" inst="$2" upd="$3"
  if [ "$_JSON_CMD" = "jq" ]; then
    jq -n --arg ver "$ver" --arg inst "$inst" --arg upd "$upd" \
      '{version:$ver,installed_at:$inst,updated_at:$upd,files:{}}'
  else
    node - "$ver" "$inst" "$upd" << 'NODESCRIPT'
      process.stdout.write(JSON.stringify(
        {version:process.argv[2],installed_at:process.argv[3],updated_at:process.argv[4],files:{}},null,2));
NODESCRIPT
  fi
}

# Set .files[KEY] = VALUE in a JSON string (stdin → stdout).
# Usage: echo "\$json" | _json_set_file KEY VALUE
_json_set_file() {
  local key="$1" val="$2"
  if [ "$_JSON_CMD" = "jq" ]; then
    jq --arg f "$key" --arg c "$val" '.files[$f] = $c'
  else
    node -e "
      const d=JSON.parse(require('fs').readFileSync('/dev/stdin','utf8'));
      d.files=d.files||{};d.files[process.argv[1]]=process.argv[2];
      process.stdout.write(JSON.stringify(d,null,2));" "$key" "$val"
  fi
}

# Read .boilerplate_files[KEY].remote_sha from a JSON file.
# Returns empty string if missing — callers treat empty as "needs pull".
# Usage: _json_get_boilerplate_remote_sha FILE KEY
_json_get_boilerplate_remote_sha() {
  local file="$1" key="$2"
  [ -f "$file" ] || {
    echo ""
    return
  }
  if [ "$_JSON_CMD" = "jq" ]; then
    jq -r --arg k "$key" '.boilerplate_files[$k].remote_sha // empty' "$file" 2> /dev/null
  else
    node - "$file" "$key" << 'NODESCRIPT' 2> /dev/null
      try {
        const d = JSON.parse(require('fs').readFileSync(process.argv[2],'utf8'));
        const v = (d.boilerplate_files||{})[process.argv[3]]?.remote_sha;
        if (v) process.stdout.write(String(v));
      } catch(e) {}
NODESCRIPT
  fi
}

# Persist a single .boilerplate_files entry into a manifest file.
# Atomically updates the file. Creates .boilerplate_files object if missing.
# Usage: _json_set_boilerplate_file MANIFEST_FILE KEY REMOTE_SHA REPO
_json_set_boilerplate_file() {
  local file="$1" key="$2" sha="$3" repo="$4"
  [ -f "$file" ] || return 1
  local ts
  ts=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
  local tmp
  tmp=$(mktemp) || return 1
  if [ "$_JSON_CMD" = "jq" ]; then
    if jq --arg k "$key" --arg s "$sha" --arg r "$repo" --arg t "$ts" \
      '.boilerplate_files = (.boilerplate_files // {}) | .boilerplate_files[$k] = {remote_sha:$s, repo:$r, fetched_at:$t}' \
      "$file" > "$tmp" 2> /dev/null; then
      mv "$tmp" "$file" || {
        rm -f "$tmp"
        return 1
      }
    else
      rm -f "$tmp"
      return 1
    fi
  else
    if node - "$file" "$tmp" "$key" "$sha" "$repo" "$ts" << 'NODESCRIPT' 2> /dev/null; then
      const fs=require('fs');
      const f=process.argv[2], t=process.argv[3];
      const d=JSON.parse(fs.readFileSync(f,'utf8'));
      d.boilerplate_files = d.boilerplate_files || {};
      d.boilerplate_files[process.argv[4]] = {
        remote_sha: process.argv[5],
        repo: process.argv[6],
        fetched_at: process.argv[7],
      };
      fs.writeFileSync(t, JSON.stringify(d, null, 2));
NODESCRIPT
      mv "$tmp" "$file" || {
        rm -f "$tmp"
        return 1
      }
    else
      rm -f "$tmp"
      return 1
    fi
  fi
}
