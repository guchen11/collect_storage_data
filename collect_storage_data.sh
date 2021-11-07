#!/bin/bash

storage_logs_home=/home/kni/storage_log
number_of_collections=30
sleep_intervals=10

log_date=$(date +%m-%d-%Y)
log_path=$storage_logs_home/storage_log_$log_date

ROOK_POD=$(oc get pods -n openshift-storage -l app=rook-ceph-operator -o name)

result=$(oc rsh -n openshift-storage $ROOK_POD ceph -c /var/lib/rook/openshift-storage/openshift-storage.config health)
substr="${result:0:9}"

if [[ "$substr" != "HEALTH_OK" ]]; then

   FILE=$storage_logs_home

   if [ ! -d "$FILE" ]; then
       mkdir $FILE
   fi

   FILE=$log_path

   #Only if new error at this date occurred collect logs
   if [ ! -d "$FILE" ]; then

        mkdir $FILE

        for (( index=1; index<=$number_of_collections; index+=1 ))
        do
                ROOK_POD=$(oc get pods -n openshift-storage -l app=rook-ceph-operator -o name)
                echo `date` >> $log_path/ceph_summary.log
                oc rsh -n openshift-storage $ROOK_POD ceph -c /var/lib/rook/openshift-storage/openshift-storage.config -s >> $log_path/ceph_summary.log

                ROOK_POD=$(oc get pods -n openshift-storage -l app=rook-ceph-operator -o name)
                echo `date` >> $log_path/ceph_osd_tree.log
                oc rsh -n openshift-storage $ROOK_POD ceph -c /var/lib/rook/openshift-storage/openshift-storage.config osd tree >> $log_path/ceph_osd_tree.log

                ROOK_POD=$(oc get pods -n openshift-storage -l app=rook-ceph-operator -o name)
                echo `date` >> $log_path/ceph_df_detail.log
                oc rsh -n openshift-storage $ROOK_POD ceph -c /var/lib/rook/openshift-storage/openshift-storage.config df detail >> $log_path/ceph_df_detail.log

                ROOK_POD=$(oc get pods -n openshift-storage -l app=rook-ceph-operator -o name)
                echo `date` >> $log_path/ceph_health_detail.log
                oc rsh -n openshift-storage $ROOK_POD ceph -c /var/lib/rook/openshift-storage/openshift-storage.config health detail >> $log_path/ceph_health_detail.log

                sleep $sleep_intervals
       done

   fi

fi

