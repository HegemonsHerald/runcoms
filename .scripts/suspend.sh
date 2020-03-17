#!/bin/bash

{ sleep "$1m"; systemctl suspend -i; }&
