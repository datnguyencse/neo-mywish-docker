#!/bin/bash
#
# This script starts four consensus and waits forever
#

screen -dmS node expect /opt/start_consensus_node.sh /opt/node/neo-cli/

sleep infinity
