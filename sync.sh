# Google spreadsheet ID to download
# In this case the URL (taken from the broswer) was:
# https://docs.google.com/spreadsheets/d/1vk-EiuitkVKbuZ_dUxLg5WAMNtt0ZtMtZ__Xs45GwZM/edit
ID="1vk-EiuitkVKbuZ_dUxLg5WAMNtt0ZtMtZ__Xs45GwZM"
# One server which can access a common remote directory
REMOTE=farm08
# The remote directory where the files should be hosted (assumes the directory exists)
REMOTE_DIR=/home/alyr/mbd
# The docker tag to use
DOCKER_TAG=mbd
# The registry where the image should be downloaded
REGISTRY=farm02.ewi.utwente.nl:5000
# Download google spread sheet as csv
wget --no-check-certificate -q -O users.csv "https://docs.google.com/spreadsheets/d/$ID/export?format=tsv&id=$ID"
# copy csv to remote hosts
scp users.csv $REMOTE:$REMOTE_DIR/
# rsync the bin directory to remote host
rsync -aug bin/ $REMOTE:$REMOTE_DIR/bin/
# start / stop the necessary notebooks
for host in $(cat hosts); do
  ssh $REMOTE_DIR/bin/manage_nbs.py --registry $REGISTRY --csv_fn $REMOTE_DIR/users.csv start $DOCKER_TAG
done
# parallized variante using pssh
# pssh -h hosts -i -t 0 $REMOTE_DIR/bin/manage_nbs.py --registry $REGISTRY --csv_fn $REMOTE_DIR/users.csv start $DOCKER_TAG