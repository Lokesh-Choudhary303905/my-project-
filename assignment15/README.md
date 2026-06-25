# Dockerized Python Application

## Overview

This project demonstrates a simple Dockerized Python application using the
python:3.12-slim base image.

The application prints:

- Current Python Version
- Current Date and Time

---

## Project Structure

```text
docker-python-app/
│
├── app.py
├── Dockerfile
├── requirements.txt
└── README.md
## Author

Lokesh Choudhary

---

## Build Command

Project folder me:

```powershell
docker build -t python-version-app .
Successfully tagged python-version-app:latest
output is=
Python Version: 3.12.11
Current Date & Time: 2026-06-25 11:20:15.123456