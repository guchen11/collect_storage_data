# collect_storage_data
collect storage data for debugging

IMPORTANT: Before using this script, ensure $LOCALHOME is set to an appropriate location to allow for the amount of data to be collected and stored.

Run the following command once on the executer machine :
oc patch OCSInitialization ocsinit -n openshift-storage --type json --patch  '[{ "op": "replace", "path": "/spec/enableCephTools", "value": true }]'

Add to crontab this script, recommended to run every minute, add * * * * * /root/collect_storage_data.sh
https://www.redhat.com/sysadmin/automate-linux-tasks-cron

Add execution permission to the script :
chmod +x collect_storage_data.sh

Setup log rotation with log_path for the amount of day's that is wanted, recommended 7 days : https://www.redhat.com/sysadmin/setting-logrotate

Change the following parameters in the script :
Storage_logs_home - the folder path you want the logs to be written to
Number_of_collections - recommended 30
sleep_intervals- recommended 10
This will collect the logs for at least 5 minutes after the health of the system is not OK.
