
# TourGuide Manager 🚀

![Project Logo](./architecture/logo.jpg)

A software development project for Innopolis University.  
This repository contains the source code and documentation for our MVP releases.

[Documentation (Website)](https://projectswd12.github.io/SWD_Project/)

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
- [docs](docs)
- [CHANGELOG.md](CHANGELOG.md)
- [LICENSE](LICENSE)

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

| Participant      | Role            | GitHub Profile                       |
|---------------|-----------------|----------------------------------------|
| Aleksey Chegaev   | Team Lead, Flutter Developer, Configure Database    | <a href="https://github.com/wyroxx"><img src="https://github.com/wyroxx.png" width="80" height="80" style="border-radius: 50%;" /><br /></a> |
| Aleksandr Medvedev | Flutter Developer     | <a href="https://github.com/BearAx"><img src="https://github.com/BearAx.png" width="80" height="80" style="border-radius: 50%;" /><br /></a> |
| Nikita Shankin    | Flutter Developer     | <a href="https://github.com/Mysteri0K1ng"><img src="https://github.com/Mysteri0K1ng.png" width="80" height="80" style="border-radius: 50%;" /><br /></a> |
| Georgii Beliaev | Web-Developer    | <a href="https://github.com/JoraXD"><img src="https://github.com/JoraXD.png" width="80" height="80" style="border-radius: 50%;" /><br /></a> |
| Alexander Simonov    | Web-Developer   | <a href="https://github.com/AlexbittIT"><img src="https://github.com/AlexbittIT.png" width="80" height="80" style="border-radius: 50%;" /><br /></a> |


External Systems:
- Firebase Authentication
- Firestore Database

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
2. `Register` in with your credentials
3. Use the `calendar` to browse excursions
4. Visit the [Admin Interface](https://tourappmanager.ru/)
5. Manage Excursions
6. `Accept` or `Reject` excursion in the Guide App

---

## Installation & Deployment

### Prerequisites
| Tool | Version |
|------|---------|
| Flutter | 3.22+ |
| Dart | 3.4+ |
| React | 18.2.0 |
| Python | 3.12.4 |
| Firebase CLI | 12+ |
| Node.js (for scripts) | 18+ |

### Local setup

```bash
git clone https://github.com/ProjectSWD12/SWD_Project.git
cd SWD_Project
flutter pub get                 # install dependencies
flutter run                     # launch on device or web
