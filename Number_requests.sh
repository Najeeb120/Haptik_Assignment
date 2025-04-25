#!/bin/bash

AWS_ACCESS_KEY_ID = " xxx"

AWS_SECRET_ACCESS_KEY = " xxx "

AWS_REGION = "us-central"

ALB_ARN = " 82992-xxx"

EC2_INSTANCE_TYPE = "t2.micro"

EC2_AMI_ID = " xxxxxx"

EC2_SECURITY_GROUP_IDS = "xx-dxx"

EC2_SUBNET_IDS = " xx-dxs"

ES_DOMAIN_NAME = " dxxt "

MONGO_INSTANCE_ID = "xx-dxx"

REQUEST_COUNT = $(aws cloudwatch get-metric-statistics  --metric-name RequestCount --namespace AWS/ApplicationELB --dimensions Name=LoadBalancer ,Value=$ALB_ARN--statistic Sum --period 300 --start-time $(date -u -d "-5 minutes" +"&Y-%m-%dT%H:%M:%SZ") --end-time $(date -u +"%Y-%m-%dT%H:%M:%SZ" --date="now") --query 'Datapoints[0].Sum' --output text)


THRESHOLD=90
SCALE_UP_COUNT=2
ES_NODES_COUNT=3
MONGODB_INSTANCE_TYPE="m4.xlarge"


if [$REQUEST_COUNT -gt $THRESHOLD]; then

  for i in $(seq 1 $SCALE_UP_COUNT): do

       INSTANCE_ID = $(aws ec2 run-instances --image-id $EC2_AMI_ID --instance-type $EC2_INSTANCE_TYPE --security-group-ids $EC2_SECURITY_GROUP_IDS
        --subnet-id $EC2_SUBNET_IDS
       --query 'Instances[0].InstanceId' --output text)

      aws elbv2 register-targets --loadbalancer-arn $ALB_ARN  --targets Id=$INSTANCE_ID
 

 done





aws es update-elasticsearch-domain-config --domain-name $ES_DOMAIN_NAME --elasticsearch-cluster -config InstanceCount = $ES_NODES_COUNT



aws ec2 stop-instances --instance-ids  $MONGODB_INSTANCE_ID --instance-ids $MONGODB_INSTANCE_ID


aws ec2 modify-instance-attribute --instance-id $MONGODB_INSTANCE_ID --instance-type $MONGODB_INSTANCE_TYPE 

aws ec2 start-instances --instance-ids $MONGODB_INSTANCE_ID

fi


