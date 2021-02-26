#!/bin/bash

# Declare connection variable
dbname=$DBNAME
username=$USERNAME
password=$PASSWORD
host=$HOST
organization=$ORG
bucket=$BUCKET
aws_access_key_id=$AWSACCESSKEYID
aws_secret_access_key=$AWSSECRETACCESSKEY

collections=$(mongo --quiet "mongodb+srv://$username:$password@$host/$dbname" --eval 'rs.slaveOk();db.getCollectionNames().join(" ");' | tail -1)
IFS=', ' read -r -a collectionArray <<<"$collections"

echo "Connected to $host @ $dbname with $username"
echo " "
exportDate=$(date -Iseconds)

aws configure set aws_access_key_id $aws_access_key_id
aws configure set aws_secret_access_key $aws_secret_access_key

while true; do
  if [ -z "$organization" ]; then
    echo "Enter organization to export: "
    read organization
  fi
  mkdir -p $PWD/$organization/$exportDate
  for ((i = 0; i < ${#collectionArray[@]}; ++i)); do
    echo "Exporting organization $organization from collection ${collectionArray[$i]}"

    mongoexport --uri="mongodb+srv://$username:$password@$host/$dbname" --collection ${collectionArray[$i]} --query="{\"organization\": {\"\$oid\": \"$organization\"}}" --out $PWD/$organization/$exportDate/${collectionArray[$i]}.json

    aws s3 cp $PWD/$organization/$exportDate/${collectionArray[$i]}.json s3://$bucket/$organization/$exportDate/${collectionArray[$i]}.json

    echo "${collectionArray[$i]} collection exported."
  done
  echo "Done. All collections have been exported here s3://$bucket/$organization/$exportDate/"
  echo "Export another organization? [y/n] :"
  read response
  if [ "$response" != "y" ]; then
    echo "Happy import! Bye!"
    break
  fi
done
