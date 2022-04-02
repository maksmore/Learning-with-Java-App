#!/bin/bash

CODE=$(curl -s --output /dev/null \
--write-out '%{http_code}' \
-H "Content-Type: application/json" \
-X POST \
-d '{"name": "maintenance"}' \
http://localhost:8080/api/v1/specialty)

if [[ "$CODE" != "200" ]]
then
    echo "FAILURE HTTP RETURN CODE!"
else
    echo "200 HTTP RETURN CODE, SUCCESS!"
fi
