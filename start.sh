#!/bin/sh

echo "[SSH] Starting SSH daemon..."
/usr/sbin/sshd

echo "[Foundry] Starting Foundry VTT..."
exec tini -- start-foundryvtt
