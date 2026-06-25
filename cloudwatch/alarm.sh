#!/bin/bash
aws cloudwatch put-metric-alarm \
  --alarm-name "High-CPU-Alert" \
  --metric-name CPUUtilization \
  --namespace AWS/EC2 \
  --statistic Average \
  --period 300 \
  --threshold 70 \
  --comparison-operator GreaterThanThreshold \
  --dimensions Name=InstanceId,Value=<YOUR_INSTANCE_ID> \
  --evaluation-periods 1 \
  --region ap-southeast-1
