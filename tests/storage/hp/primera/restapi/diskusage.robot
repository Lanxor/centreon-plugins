*** Settings ***
Documentation       HPE Primera Storage REST API

Resource            ${CURDIR}${/}..${/}..${/}..${/}..${/}resources/import.resource

Suite Setup         Start Mockoon    ${MOCKOON_JSON}
Suite Teardown      Stop Mockoon
Test Timeout        120s

*** Variables ***
${MOCKOON_JSON}     ${CURDIR}${/}hpe-primera.mockoon.json
${HOSTNAME}             127.0.0.1
${APIPORT}              3000
${CMD}              ${CENTREON_PLUGINS} 
...                 --plugin=storage::hp::primera::restapi::plugin
...                 --mode=disk-usage
...                 --hostname=${HOSTNAME}
...                 --api-username=toto
...                 --api-password=toto
...                 --proto=http
...                 --port=${APIPORT}
...                 --custommode=api
...                 --statefile-dir=/dev/shm/

*** Test Cases ***
Disk Usage ${tc}
    [Tags]    storage     api    hpe    hp
    ${output}    Run    ${CMD} ${extraoptions}

    ${output}    Strip String    ${output}

    Should Be Equal As Strings
    ...    ${output}
    ...    ${expected_result}
    ...    Wrong output result for command:\n${CMD} ${extraoptions}\n\nObtained:\n${output}\n\nExpected:\n${expected_result}\n
    ...    values=False
    ...    collapse_spaces=True

    Examples:    tc       extraoptions                                                                                           expected_result   --
        ...      1        --filter-manufacturer=SAMSUNG --filter-counters='^usage$'                                              OK: All disks are ok | '0#disk.space.usage.bytes'=652835028992B;;;0;1918776639488 '1#disk.space.usage.bytes'=651761287168B;;;0;1918776639488 '14#disk.space.usage.bytes'=1006096089088B;;;0;1918776639488 '15#disk.space.usage.bytes'=1006096089088B;;;0;1918776639488 '2#disk.space.usage.bytes'=652835028992B;;;0;1918776639488 '26#disk.space.usage.bytes'=1006096089088B;;;0;1918776639488 '27#disk.space.usage.bytes'=1006096089088B;;;0;1918776639488 '3#disk.space.usage.bytes'=651761287168B;;;0;1918776639488 '38#disk.space.usage.bytes'=651761287168B;;;0;1918776639488 '39#disk.space.usage.bytes'=650687545344B;;;0;1918776639488 '40#disk.space.usage.bytes'=651761287168B;;;0;1918776639488 '41#disk.space.usage.bytes'=650687545344B;;;0;1918776639488 '50#disk.space.usage.bytes'=1006096089088B;;;0;1918776639488 '51#disk.space.usage.bytes'=1006096089088B;;;0;1918776639488
        ...      2        --filter-manufacturer=SAMSUNG --filter-counters='^usage-free$'                                         OK: All disks are ok | '0#disk.space.free.bytes'=652835028992B;;;0;1918776639488 '1#disk.space.free.bytes'=651761287168B;;;0;1918776639488 '14#disk.space.free.bytes'=1006096089088B;;;0;1918776639488 '15#disk.space.free.bytes'=1006096089088B;;;0;1918776639488 '2#disk.space.free.bytes'=652835028992B;;;0;1918776639488 '26#disk.space.free.bytes'=1006096089088B;;;0;1918776639488 '27#disk.space.free.bytes'=1006096089088B;;;0;1918776639488 '3#disk.space.free.bytes'=651761287168B;;;0;1918776639488 '38#disk.space.free.bytes'=651761287168B;;;0;1918776639488 '39#disk.space.free.bytes'=650687545344B;;;0;1918776639488 '40#disk.space.free.bytes'=651761287168B;;;0;1918776639488 '41#disk.space.free.bytes'=650687545344B;;;0;1918776639488 '50#disk.space.free.bytes'=1006096089088B;;;0;1918776639488 '51#disk.space.free.bytes'=1006096089088B;;;0;1918776639488
        ...      3        --filter-manufacturer=SAMSUNG --filter-counters='^usage-prct$'                                         OK: All disks are ok | '0#disk.space.usage.percentage'=34.02%;;;0;100 '1#disk.space.usage.percentage'=33.97%;;;0;100 '14#disk.space.usage.percentage'=52.43%;;;0;100 '15#disk.space.usage.percentage'=52.43%;;;0;100 '2#disk.space.usage.percentage'=34.02%;;;0;100 '26#disk.space.usage.percentage'=52.43%;;;0;100 '27#disk.space.usage.percentage'=52.43%;;;0;100 '3#disk.space.usage.percentage'=33.97%;;;0;100 '38#disk.space.usage.percentage'=33.97%;;;0;100 '39#disk.space.usage.percentage'=33.91%;;;0;100 '40#disk.space.usage.percentage'=33.97%;;;0;100 '41#disk.space.usage.percentage'=33.91%;;;0;100 '50#disk.space.usage.percentage'=52.43%;;;0;100 '51#disk.space.usage.percentage'=52.43%;;;0;100
        ...      4        --filter-manufacturer=SAMSUNG --filter-counters='total'                                                OK: Total Used: 10.23 TB / 24.43 TB, Total percentage used: 41.88 %, Total Free: 14.20 TB | 'disks.total.space.usage.bytes'=11250666831872;;;0;26862872952832 'disks.total.space.usage.percent'=41.8818450715485;;;0;100 'disks.total.space.free.bytes'=15612206120960;;;0;26862872952832
        ...      5        --filter-manufacturer=SAMSUNG --filter-counters='total' --warning-total-usage=5                        WARNING: Total Used: 10.23 TB / 24.43 TB | 'disks.total.space.usage.bytes'=11250666831872;0:5;;0;26862872952832 'disks.total.space.usage.percent'=41.8818450715485;;;0;100 'disks.total.space.free.bytes'=15612206120960;;;0;26862872952832
        ...      6        --filter-manufacturer=SAMSUNG --filter-counters='total' --critical-total-usage=5                       CRITICAL: Total Used: 10.23 TB / 24.43 TB | 'disks.total.space.usage.bytes'=11250666831872;;0:5;0;26862872952832 'disks.total.space.usage.percent'=41.8818450715485;;;0;100 'disks.total.space.free.bytes'=15612206120960;;;0;26862872952832
        ...      7        --filter-manufacturer=SAMSUNG --filter-counters='total' --warning-total-usage-prct=35                  WARNING: Total percentage used: 41.88 % | 'disks.total.space.usage.bytes'=11250666831872;;;0;26862872952832 'disks.total.space.usage.percent'=41.8818450715485;0:35;;0;100 'disks.total.space.free.bytes'=15612206120960;;;0;26862872952832
        ...      8        --filter-manufacturer=SAMSUNG --filter-counters='total' --critical-total-usage-prct=35                 CRITICAL: Total percentage used: 41.88 % | 'disks.total.space.usage.bytes'=11250666831872;;;0;26862872952832 'disks.total.space.usage.percent'=41.8818450715485;;0:35;0;100 'disks.total.space.free.bytes'=15612206120960;;;0;26862872952832
        ...      9        --filter-manufacturer=SAMSUNG --filter-counters='^usage$' --warning-usage=1000000000000                WARNING: Disk #14 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600288) located 2:0:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #15 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600290) located 2:1:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #26 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600289) located 3:0:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #27 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600293) located 3:1:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #50 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600297) located 5:0:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #51 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600287) located 5:1:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) | '0#disk.space.usage.bytes'=652835028992B;0:1000000000000;;0;1918776639488 '1#disk.space.usage.bytes'=651761287168B;0:1000000000000;;0;1918776639488 '14#disk.space.usage.bytes'=1006096089088B;0:1000000000000;;0;1918776639488 '15#disk.space.usage.bytes'=1006096089088B;0:1000000000000;;0;1918776639488 '2#disk.space.usage.bytes'=652835028992B;0:1000000000000;;0;1918776639488 '26#disk.space.usage.bytes'=1006096089088B;0:1000000000000;;0;1918776639488 '27#disk.space.usage.bytes'=1006096089088B;0:1000000000000;;0;1918776639488 '3#disk.space.usage.bytes'=651761287168B;0:1000000000000;;0;1918776639488 '38#disk.space.usage.bytes'=651761287168B;0:1000000000000;;0;1918776639488 '39#disk.space.usage.bytes'=650687545344B;0:1000000000000;;0;1918776639488 '40#disk.space.usage.bytes'=651761287168B;0:1000000000000;;0;1918776639488 '41#disk.space.usage.bytes'=650687545344B;0:1000000000000;;0;1918776639488 '50#disk.space.usage.bytes'=1006096089088B;0:1000000000000;;0;1918776639488 '51#disk.space.usage.bytes'=1006096089088B;0:1000000000000;;0;1918776639488
        ...     10        --filter-manufacturer=SAMSUNG --filter-counters='^usage$' --critical-usage=1000000000000               CRITICAL: Disk #14 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600288) located 2:0:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #15 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600290) located 2:1:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #26 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600289) located 3:0:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #27 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600293) located 3:1:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #50 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600297) located 5:0:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) - Disk #51 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600287) located 5:1:0 has Used: 937.00 GB of 1.75 TB (52.43%) Free: 850.00 GB (47.57%) | '0#disk.space.usage.bytes'=652835028992B;;0:1000000000000;0;1918776639488 '1#disk.space.usage.bytes'=651761287168B;;0:1000000000000;0;1918776639488 '14#disk.space.usage.bytes'=1006096089088B;;0:1000000000000;0;1918776639488 '15#disk.space.usage.bytes'=1006096089088B;;0:1000000000000;0;1918776639488 '2#disk.space.usage.bytes'=652835028992B;;0:1000000000000;0;1918776639488 '26#disk.space.usage.bytes'=1006096089088B;;0:1000000000000;0;1918776639488 '27#disk.space.usage.bytes'=1006096089088B;;0:1000000000000;0;1918776639488 '3#disk.space.usage.bytes'=651761287168B;;0:1000000000000;0;1918776639488 '38#disk.space.usage.bytes'=651761287168B;;0:1000000000000;0;1918776639488 '39#disk.space.usage.bytes'=650687545344B;;0:1000000000000;0;1918776639488 '40#disk.space.usage.bytes'=651761287168B;;0:1000000000000;0;1918776639488 '41#disk.space.usage.bytes'=650687545344B;;0:1000000000000;0;1918776639488 '50#disk.space.usage.bytes'=1006096089088B;;0:1000000000000;0;1918776639488 '51#disk.space.usage.bytes'=1006096089088B;;0:1000000000000;0;1918776639488
        ...     11        --filter-manufacturer=SAMSUNG --filter-counters='^usage-prct$' --warning-usage-prct=35                 WARNING: Disk #14 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600288) located 2:0:0 has Used : 52.43 % - Disk #15 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600290) located 2:1:0 has Used : 52.43 % - Disk #26 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600289) located 3:0:0 has Used : 52.43 % - Disk #27 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600293) located 3:1:0 has Used : 52.43 % - Disk #50 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600297) located 5:0:0 has Used : 52.43 % - Disk #51 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600287) located 5:1:0 has Used : 52.43 % | '0#disk.space.usage.percentage'=34.02%;0:35;;0;100 '1#disk.space.usage.percentage'=33.97%;0:35;;0;100 '14#disk.space.usage.percentage'=52.43%;0:35;;0;100 '15#disk.space.usage.percentage'=52.43%;0:35;;0;100 '2#disk.space.usage.percentage'=34.02%;0:35;;0;100 '26#disk.space.usage.percentage'=52.43%;0:35;;0;100 '27#disk.space.usage.percentage'=52.43%;0:35;;0;100 '3#disk.space.usage.percentage'=33.97%;0:35;;0;100 '38#disk.space.usage.percentage'=33.97%;0:35;;0;100 '39#disk.space.usage.percentage'=33.91%;0:35;;0;100 '40#disk.space.usage.percentage'=33.97%;0:35;;0;100 '41#disk.space.usage.percentage'=33.91%;0:35;;0;100 '50#disk.space.usage.percentage'=52.43%;0:35;;0;100 '51#disk.space.usage.percentage'=52.43%;0:35;;0;100
        ...     12        --filter-manufacturer=SAMSUNG --filter-counters='^usage-prct$' --critical-usage-prct=35                CRITICAL: Disk #14 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600288) located 2:0:0 has Used : 52.43 % - Disk #15 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600290) located 2:1:0 has Used : 52.43 % - Disk #26 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600289) located 3:0:0 has Used : 52.43 % - Disk #27 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600293) located 3:1:0 has Used : 52.43 % - Disk #50 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600297) located 5:0:0 has Used : 52.43 % - Disk #51 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600287) located 5:1:0 has Used : 52.43 % | '0#disk.space.usage.percentage'=34.02%;;0:35;0;100 '1#disk.space.usage.percentage'=33.97%;;0:35;0;100 '14#disk.space.usage.percentage'=52.43%;;0:35;0;100 '15#disk.space.usage.percentage'=52.43%;;0:35;0;100 '2#disk.space.usage.percentage'=34.02%;;0:35;0;100 '26#disk.space.usage.percentage'=52.43%;;0:35;0;100 '27#disk.space.usage.percentage'=52.43%;;0:35;0;100 '3#disk.space.usage.percentage'=33.97%;;0:35;0;100 '38#disk.space.usage.percentage'=33.97%;;0:35;0;100 '39#disk.space.usage.percentage'=33.91%;;0:35;0;100 '40#disk.space.usage.percentage'=33.97%;;0:35;0;100 '41#disk.space.usage.percentage'=33.91%;;0:35;0;100 '50#disk.space.usage.percentage'=52.43%;;0:35;0;100 '51#disk.space.usage.percentage'=52.43%;;0:35;0;100
        ...     13        --filter-manufacturer=SAMSUNG --filter-counters='^usage-free$' --warning-usage-free=1000000000000:     WARNING: Disk #0 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600283) located 0:0:0 has Used: 608.00 GB of 1.75 TB (34.02%) Free: 1.15 TB (65.98%) - Disk #1 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600286) located 0:1:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #2 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600197) located 0:2:0 has Used: 608.00 GB of 1.75 TB (34.02%) Free: 1.15 TB (65.98%) - Disk #3 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600285) located 0:3:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #38 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600303) located 4:0:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #39 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600302) located 4:1:0 has Used: 606.00 GB of 1.75 TB (33.91%) Free: 1.15 TB (66.09%) - Disk #40 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600296) located 4:2:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #41 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600291) located 4:3:0 has Used: 606.00 GB of 1.75 TB (33.91%) Free: 1.15 TB (66.09%) | '0#disk.space.free.bytes'=652835028992B;1000000000000:;;0;1918776639488 '1#disk.space.free.bytes'=651761287168B;1000000000000:;;0;1918776639488 '14#disk.space.free.bytes'=1006096089088B;1000000000000:;;0;1918776639488 '15#disk.space.free.bytes'=1006096089088B;1000000000000:;;0;1918776639488 '2#disk.space.free.bytes'=652835028992B;1000000000000:;;0;1918776639488 '26#disk.space.free.bytes'=1006096089088B;1000000000000:;;0;1918776639488 '27#disk.space.free.bytes'=1006096089088B;1000000000000:;;0;1918776639488 '3#disk.space.free.bytes'=651761287168B;1000000000000:;;0;1918776639488 '38#disk.space.free.bytes'=651761287168B;1000000000000:;;0;1918776639488 '39#disk.space.free.bytes'=650687545344B;1000000000000:;;0;1918776639488 '40#disk.space.free.bytes'=651761287168B;1000000000000:;;0;1918776639488 '41#disk.space.free.bytes'=650687545344B;1000000000000:;;0;1918776639488 '50#disk.space.free.bytes'=1006096089088B;1000000000000:;;0;1918776639488 '51#disk.space.free.bytes'=1006096089088B;1000000000000:;;0;1918776639488
        ...     14        --filter-manufacturer=SAMSUNG --filter-counters='^usage-free$' --critical-usage-free=1000000000000:    CRITICAL: Disk #0 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600283) located 0:0:0 has Used: 608.00 GB of 1.75 TB (34.02%) Free: 1.15 TB (65.98%) - Disk #1 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600286) located 0:1:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #2 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600197) located 0:2:0 has Used: 608.00 GB of 1.75 TB (34.02%) Free: 1.15 TB (65.98%) - Disk #3 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600285) located 0:3:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #38 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600303) located 4:0:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #39 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600302) located 4:1:0 has Used: 606.00 GB of 1.75 TB (33.91%) Free: 1.15 TB (66.09%) - Disk #40 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600296) located 4:2:0 has Used: 607.00 GB of 1.75 TB (33.97%) Free: 1.15 TB (66.03%) - Disk #41 (SAMSUNG/ARFA1920S5xnFTRI, serial: 0T600291) located 4:3:0 has Used: 606.00 GB of 1.75 TB (33.91%) Free: 1.15 TB (66.09%) | '0#disk.space.free.bytes'=652835028992B;;1000000000000:;0;1918776639488 '1#disk.space.free.bytes'=651761287168B;;1000000000000:;0;1918776639488 '14#disk.space.free.bytes'=1006096089088B;;1000000000000:;0;1918776639488 '15#disk.space.free.bytes'=1006096089088B;;1000000000000:;0;1918776639488 '2#disk.space.free.bytes'=652835028992B;;1000000000000:;0;1918776639488 '26#disk.space.free.bytes'=1006096089088B;;1000000000000:;0;1918776639488 '27#disk.space.free.bytes'=1006096089088B;;1000000000000:;0;1918776639488 '3#disk.space.free.bytes'=651761287168B;;1000000000000:;0;1918776639488 '38#disk.space.free.bytes'=651761287168B;;1000000000000:;0;1918776639488 '39#disk.space.free.bytes'=650687545344B;;1000000000000:;0;1918776639488 '40#disk.space.free.bytes'=651761287168B;;1000000000000:;0;1918776639488 '41#disk.space.free.bytes'=650687545344B;;1000000000000:;0;1918776639488 '50#disk.space.free.bytes'=1006096089088B;;1000000000000:;0;1918776639488 '51#disk.space.free.bytes'=1006096089088B;;1000000000000:;0;1918776639488
