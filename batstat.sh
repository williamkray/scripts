#!/bin/bash
bat=$(acpi|sed 's/\ 0\://g') && notify-send "$bat"
