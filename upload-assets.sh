#!/bin/bash

tag="$1"
repo_dir="$2"
artifacts_dir="$3"

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
       URL="https://api.telegram.org/bot$BOT_TOKEN/sendDocument"
       curl -s -X POST "$URL" -F document=@"$escaped_kernel" -F caption="$CAPTION" -F chat_id="$CHAT_ID"
       cd $artifacts_dir
       rm -rf $kernel
       echo "--- Cleaned up $kernel ---"
    fi
done
