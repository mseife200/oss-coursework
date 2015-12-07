#!/bin/bash
cp /var/log/audit/audit.log ~/audit.log.tmp
#we don't care about the file content
curl localhost/sub/file.html > /dev/null
diff /var/log/audit/audit.log ~/audit.log.tmp
#remove the temporarily stored log copy
rm ~/audit.log.tmp

