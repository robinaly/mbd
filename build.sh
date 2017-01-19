#!/bin/bash
for image in base-notebook minimal-notebook scipy-notebook pyspark-notebook; do 
  docker build -t jupyter/$image $image
  docker tag jupyter/$image farm02.ewi.utwente.nl:5000/$image
done
docker tag pyspark-notebook farm02.ewi.utwente.nl:5000/mbd
docker push farm02.ewi.utwente.nl:5000/mbd
