#!/bin/bash

#FlowPlotter is a script that allows for the "easy" integration of SiLK results into various Google Visualization Chart APIs.

#timelinetimelinetimelinetimelinetimelinetimelinetimelinetimelinetimelinetimelinetimeline
timeline () {
#Variable Creation
#independent variable is a string
#dependent variable is a string
title='Suspicious Server Traffic'
title="$1 by $2"
independent="$1"
dependent="$2"
if [ -z "${independent}" ]; then
independent="sip"
fi
if [ -z "${dependent}" ]; then
dependent="dip"
fi
graphtitle="$independent by $dependent over time"
##############################

sed '/dataplaceholder/{
    s/dataplaceholder//g
    r temp.test
}' googlechart/timeline.html | sed "s/titleplaceholder/${graphtitle}/g"

rm temp.test
}
#timelinetimelinetimelinetimelinetimelinetimelinetimelinetimelinetimelinetimelinetimeline



#forceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacity
forceopacity () {
#Variable Creation
#source variable is a string
#target variable is a string
#value is an string
title="$1 by $2"
source="$1"
if [ -z "$source" ]; then
source="sip"
echo "No source variable provided. Defaulting to sip"
fi
target="$2"
if [ -z "$target" ]; then
target="dip"
echo "No target variable provided. Defaulting to dip"
fi
value="$3"
if [ -z "$value" ]; then
value="bytes"
echo "No value variable provided. Defaulting to bytes"
fi
graphtitle="source-target-value"
#####################
#replace #rwstats --top --count=$count --fields=$source,$target --value=$value --delimited=, --no-titles | cut -d ',' -f1,2,3 | sed '1 s/^/source,target,value\n/' > d3chart/force.csv
bro-cut -F , $1,$2,$3 | sed '1 s/^/source,target,value\n/' >> temp.test

sed '/dataplaceholder/{
    s/dataplaceholder//g
    r temp.test
}' d3chart/forceopacity.html | sed "s/titleplaceholder/${graphtitle}/g"

rm temp.test

}
#forceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacityforceopacity


#Function Initiation

if [ "$1" == "-h" ]; then
  cat README.md
  echo -e "\n"
  exit 0
fi

if [ "$1" != "timeline"  -a "$1" != "forceopacity" ]; then
echo ""
echo "ERROR: You must specify a support chart type. "
echo ""
echo "The only supported chart types for flowplotter are:"
echo "./broplotter forceopacity [source] [target] [value]"
echo ""
echo "flowplotter --help"
echo "./flowplotter -h"
echo ""
exit 0
fi

#if [ "$1" = "timeline" ]; then
#timeline $2 $3
#fi
if [ "$1" = "forceopacity" ]; then
forceopacity $2 $3 $4
fi
