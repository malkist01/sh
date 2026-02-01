#!/bin/bash

tag="$1"
repo_dir="$2"
artifacts_dir="$3"

# ===== Set timezone =====
export TZ=Asia/Jakarta;

# ===== TELEGRAM CONFIG =====
BOT_TOKEN="7868194496:AAGY7WwRRbeCOPYOnczoCPh2psC43Q0F3JI"
CHAT_ID="-1002287610863"
API_URL="https://api.telegram.org/bot${BOT_TOKEN}"

tg_msg() {
curl -s -X POST "${API_URL}/sendMessage" \
-d chat_id="${CHAT_ID}" \
-d text="$1" \
-d parse_mode=HTML > /dev/null
}

tg_file() {
curl -s -X POST "${API_URL}/sendDocument" \
-F chat_id="${CHAT_ID}" \
-F document=@"$1" \
-F caption="$2" > /dev/null
}

cd $artifacts_dir
for kernel in *; do
    if [ -d "$kernel" ]; then
       escaped_kernel=$(printf '%q' "$kernel")
       echo "--- Zipping $kernel... ---"
       cd $kernel
       zip -r "$kernel.zip" .
       echo "--- Finished zipping $kernel ---"
       echo "--- Uploading $escaped_kernel.zip... ---"
       cd $repo_dir
       gh release upload "$tag" "$artifacts_dir/$escaped_kernel/$escaped_kernel.zip"
       echo "--- $escaped_kernel uploaded ---"
       cd $artifacts_dir
       rm -rf $kernel
       echo "--- Cleaned up $kernel ---"
    fi
done
