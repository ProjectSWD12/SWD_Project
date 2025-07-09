
# TourGuide Manager 🚀

![Project Logo](docs/architecture/logo.jpg)

A software development project for Innopolis University.  
This repository contains the source code and documentation for our MVP releases.

## 📍 Live Demo  
[👉 Deployed Version]
- [![For Guides](https://img.shields.io/badge/For-Guides-purple?logo=vercel)](https://tourapp-66e02.web.app/) 
- [![For Admins](https://img.shields.io/badge/For-Admins-purple?logo=square)](https://tourappmanager.ru/) 

[![Watch Demo Video](https://img.shields.io/badge/Watch-2 min demo-ff69b4?logo=youtube)](https://youtube.demo.link)

[![MIT License](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)
---

## 📌 Table of Contents
- [About the Project](#-about-the-project)
- [Project Context](#-project-context)
- [Feature Roadmap](#-feature-roadmap)
- [Usage Guide](#-usage-guide)
- [Installation & Deployment](#installation--deployment)
- [Documentation](#documentation)
- [Changelog](#changelog)
- [License](#license)

---

## 🧠 About the Project

This project aims to centralize and streamline tour-guide management by providing a single, always-up-to-date hub for routes, payment status, statistics, participant lists, and direct manager communication-eliminating the need for scattered Telegram notifications.  
Our goals are:
- ✅ Deliver a user-friendly MVP
- ✅ Gather feedback via customer testing
- ✅ Improve usability and performance iteratively

It is built using technologies such as **Flutter**, **Firebase**, and **GitHub Actions** for CI/CD.

---

## 👥 Project Context

Stakeholders:
- Customers: _Karina Shavalieva (@K_Arbyzova)_, _Hannanov Rishat (@RishatHannanov)_
- Developers:

| Participant      | Role            | GitHub Link                       |
|---------------|-----------------|----------------------------------------|
| Aleksey Chegaev   | Team Lead, Configure Database    | [github.com/wyroxx](https://github.com/wyroxx) |
| Aleksandr Medvedev | Flutter Developer     | [github.com/BearAx](https://github.com/BearAx) |
| Nikita Shankin    | Flutter Developer     | [github.com/Mysteri0K1ng](https://github.com/Mysteri0K1ng) |
| Georgii Beliaev | Web-Developer    | [github.com/JoraXD](https://github.com/JoraXD) |
| Alexander Simonov    | Web-Developer   | [github.com/AlexbittIT](https://github.com/AlexbittIT) |


External Systems:
- Firebase Authentication
- Firestore Database
- Telegram Bot API (if used)

📌 Context Diagram:  
> Stakeholders and external systems at a glance.
> 
![Context Diagram](docs/architecture/context-diagram.png)

---

## ✅ Feature Roadmap

| Feature (MVP tag)                               | Status       |
|----------------------------------------|--------------|
| User Login / Auth (v1.0)                     | ✅ Implemented |
| Excursion Listing (v1.0)                     | ✅ Implemented |
| Profile Management (v1.0)                    | ✅ Implemented |
| Guide's Calendar Integration (v1.0)          | ✅ Implemented |
| Admin's Calendar Integration (v2.0)          | ✅ Implemented |
| Blacklist of Users (v2.0)                    | ✅ Implemented |
| Blacklist of Guides (v2.0)                   | ✅ Implemented |
| Application Window (v2.0)                   | ✅ Implemented |
| Customer Feedback & Testing            | ⏳ In Progress |
| Real Time Notifications (v3.0)        | ⬜ Planned |

---

## 🧾 Usage Guide

1. Visit the [Guide Interaface](https://tourapp-66e02.web.app/)
2. Register in with your credentials
3. Use the calendar to browse excursions
4. Visit the [Admin Interface](https://tourappmanager.ru/)
5. Manage Excursions

Even users who say _“I just copy and paste without reading”_ will find the interface intuitive and straightforward.

---

## Installation & Deployment

### Prerequisites
| Tool | Version |
|------|---------|
| Flutter | 3.22+ |
| Dart | 3.4+ |
| Firebase CLI | 12+ |
| Node.js (for scripts) | 18+ |

### Local setup

```bash
git clone https://github.com/ProjectSWD12/SWD_Project.git
cd SWD_Project
flutter pub get                 # install dependencies
cp .env.example .env            # add your secrets
firebase emulators:start &      # (optional) run local Firebase
flutter run                     # launch on device or web
