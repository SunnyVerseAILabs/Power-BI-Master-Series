# SunnyVerse Power BI Master Series

Welcome to the official learner repository for the **SunnyVerse Power BI Master Series**.

This repository contains the learner-facing resources used throughout the complete ten-module Power BI learning journey. The series is designed to move from analytical thinking and Power BI foundations through data preparation, semantic modeling, DAX, report engineering, governance, deployment, troubleshooting, and an end-to-end enterprise capstone.

> **Important:** This repository is provided for individual learning and practice only. The files, guides, datasets, solutions, screenshots, course structure, and other learning materials may not be republished, redistributed, incorporated into another course, or used to create competing educational content. See [LICENSE.md](./LICENSE.md) for the complete terms.

---

## About the Series

The SunnyVerse Power BI Master Series is an applied learning program built around practical business-intelligence workflows rather than isolated feature demonstrations.

Across the series, learners work progressively through the complete Power BI lifecycle:

- translating business questions into analytical requirements;
- understanding Power BI architecture and data connectivity;
- preparing and transforming data with Power Query and M;
- designing semantic models and relationships;
- building measures with DAX and understanding evaluation context;
- applying advanced analytical patterns and performance techniques;
- engineering reports and analytical experiences;
- working with Power BI Service, security, refresh, governance, and deployment;
- diagnosing production problems and validating solutions; and
- integrating the complete workflow in an enterprise capstone.

The repository is intended to support the accompanying SunnyVerse video lessons and podcast learning experiences.

---

## Series Modules

### Module 1 — Analytics, Business Intelligence & Decision Systems
Build the analytical foundation before deep Power BI mechanics. Topics include business problems, decisions, analytical requirements, grain, facts, dimensions, measures, metrics, KPIs, data quality, trust, governance, stakeholders, and decision-ready intelligence.

### Module 2 — Power BI Ecosystem, Architecture & Data Connectivity
Understand the Power BI ecosystem, architecture, storage and connectivity concepts, data sources, import behavior, connectivity patterns, source inspection, and the foundations required for reliable analytical solutions.

### Module 3 — Power Query, Data Preparation & M
Learn source inspection, profiling, data types, cleaning, filtering, replacement, column operations, reshaping, combining, append, merge, pivot, unpivot, query architecture, parameters, reusable transformations, M, query dependencies, query folding, performance, data-quality handling, and transformation failure recovery.

### Module 4 — Semantic Modeling & Relationship Architecture
Design a robust semantic model using appropriate table structures, relationships, cardinality, filter direction, date structures, bridge tables, role-playing dimensions, model validation, and dimensional-model principles.

### Module 5 — DAX Foundations, Evaluation Context & CALCULATE
Build a correct mental model of DAX, measures, row context, filter context, context transition, CALCULATE, filter modifiers, and foundational calculation patterns.

### Module 6 — Advanced DAX, Analytical Patterns & Performance
Extend DAX into more advanced analytical patterns, time-aware calculations, iterator-based logic, virtual tables, performance reasoning, debugging, and maintainable measure design.

### Module 7 — Visualization, Report Engineering, Analytics & Copilot
Engineer decision-ready reports using appropriate visual design, interactions, navigation, analytical features, accessibility principles, performance considerations, and supported AI-assisted capabilities.

### Module 8 — Power BI Service, Security, Refresh & Governance
Move from desktop development into managed Power BI environments, including publishing, workspaces, permissions, row-level security, refresh, gateways, governance, sharing, lineage, and operational controls.

### Module 9 — Enterprise Lifecycle, Deployment & Production Troubleshooting
Understand lifecycle management, deployment, validation, production readiness, release discipline, monitoring, incident diagnosis, recovery, change management, and enterprise troubleshooting practices.

### Module 10 — End-to-End Enterprise Power BI Capstone
Integrate the complete learning journey into an end-to-end enterprise solution that brings together data preparation, modeling, DAX, report engineering, service deployment, security, governance, validation, and production thinking.

---

## Repository Structure

The repository is organized by module. A module may contain the following learner-facing resources depending on the activities in that module:

```text
Power-BI-Master-Series/
│
├── README.md
├── LICENSE.md
│
├── Module_01/
│   ├── 01_Module_01_Detailed_Build_Guide.docx
│   ├── 02_Module_01_Knowledge_Check.docx
│   ├── Guide_Images/
│   ├── Practice/
│   ├── Source_Files/
│   └── Validation/
│
├── Module_02/
├── Module_03/
├── Module_04/
├── Module_05/
├── Module_06/
├── Module_07/
├── Module_08/
├── Module_09/
└── Module_10/
```

Not every module is required to contain every folder. The contents reflect the learning objectives and practical activities of that module.

### Detailed Build Guide

The detailed build guide is the primary learner execution document. It explains the build process step by step, including expected states, validation checkpoints, troubleshooting guidance, and important decision points.

### Knowledge Check

Knowledge-check resources reinforce concepts, analytical reasoning, implementation choices, and troubleshooting skills covered in the module.

### Guide Images

Guide images support steps where a visual reference materially improves clarity.

### Practice

The `Practice` folder contains files intended to be opened, modified, completed, or extended by the learner during the practical workflow.

### Source Files

The `Source_Files` folder contains learner inputs such as datasets, source extracts, business-context material, SQL resources, spreadsheets, or other evidence required by the module.

Some source files may intentionally contain imperfect data, schema differences, data-quality problems, or other conditions required by the learning exercise. Do not assume that every imperfection is an error in the package.

### Validation

The `Validation` folder may contain expected-results material, checkpoints, completed reference artifacts, or other resources that help learners verify their work after completing the required activity.

---

## Recommended Learning Workflow

For each module:

1. Watch or follow the corresponding SunnyVerse lesson.
2. Read the module's Detailed Build Guide before making major changes.
3. Use the files from `Source_Files` as the authoritative learner inputs for that module.
4. Perform the practical work in the designated practice files or in your own local working copy.
5. Validate your work at the checkpoints described in the guide.
6. Use `Validation` resources only when instructed or when you need to compare your result with the expected state.
7. Complete the Knowledge Check after the practical workflow.
8. Keep your own working copy before moving to the next module.

The course is intentionally progressive. Later modules may depend on concepts, model structures, terminology, or business context established earlier in the series.

---

## Software and Environment

Depending on the module, learners may use software such as:

- Microsoft Power BI Desktop;
- Microsoft Power BI Service;
- Microsoft SQL Server Developer Edition;
- SQL Server Management Studio (SSMS);
- Microsoft Excel or compatible spreadsheet tools; and
- supporting files and services identified in the corresponding module guide.

Software versions and product interfaces may change over time. Follow the module guide and the current supported product documentation when an interface differs from the recorded lesson.

---

## Downloading the Learner Files

You may use GitHub's normal repository features to obtain a personal learning copy of the materials.

Typical options include:

- opening an individual file and downloading it;
- cloning the repository for your own private learning environment; or
- using GitHub's **Download ZIP** option for a local copy.

Downloading or cloning the repository does **not** grant permission to republish, redistribute, mirror, sell, teach from, or incorporate the materials into another course or educational product.

---

## Permitted Learner Use

Subject to the complete terms in [LICENSE.md](./LICENSE.md), learners may:

- download the learner materials for personal study;
- use the files to follow the SunnyVerse lessons;
- create private working copies;
- modify practice files for their own learning;
- create personal notes and exercises; and
- retain reasonable local backup copies for their own use.

Learners may also create their own original portfolio descriptions or screenshots showing what they personally built, provided those posts do not distribute SunnyVerse source files, datasets, detailed guide text, completed reference files, substantial solution content, or other protected course materials.

---

## Prohibited Uses

Unless you have prior written permission from the copyright owner, you may **not**:

- republish or redistribute the repository or any substantial portion of it;
- upload the learner files to another GitHub repository, website, cloud drive, forum, LMS, file-sharing service, or download site;
- create a mirror, archive, or public copy of the course materials;
- sell, rent, sublicense, bundle, or commercially exploit the materials;
- use the materials to create another course, tutorial series, bootcamp, workshop, training program, certification-preparation product, book, video series, or educational package;
- copy or closely reproduce the course structure, detailed build instructions, solutions, screenshots, datasets, exercises, or validation materials for redistribution;
- remove or alter copyright, ownership, branding, or usage notices;
- use SunnyVerse names, logos, characters, visual identity, or branding in a manner that implies authorization or affiliation;
- use the repository as training data, evaluation data, or a content corpus for training or fine-tuning a model without written permission; or
- help another person or organization perform any prohibited activity above.

Attribution alone does not create permission for a prohibited use.

---

## Public Repository Notice

This is a public GitHub repository so learners can conveniently access the official materials.

Public visibility does not place the contents in the public domain and does not convert them into open-source or freely redistributable educational content. Copyright and the accompanying license terms continue to apply to the repository contents.

The ability of a hosting platform to technically display, cache, clone, or fork repository content does not expand the permissions granted to users under the SunnyVerse license.

---

## Course Integrity

For the best learning experience:

- preserve original source files before modifying them;
- work from copies when the guide instructs you to transform or intentionally break a resource;
- do not replace source files with completed validation versions;
- follow the module sequence when dependencies exist; and
- compare your result with validation material only after attempting the required build or analytical task.

This structure is intended to preserve repeatability and make troubleshooting easier.

---

## Corrections and Version Updates

Course files may be updated when:

- a software interface changes;
- a learner-facing instruction requires clarification;
- a source file needs correction;
- a validation checkpoint is improved; or
- a later module requires a controlled revision to shared course resources.

When downloading files, use the most recent version available in this official repository unless a lesson explicitly instructs you to use a specific release or checkpoint.

---

## Copyright and Ownership

Unless otherwise stated inside a specific third-party file:

**Copyright © 2026 SunnyVerse AI Labs. All Rights Reserved.**

The SunnyVerse Power BI Master Series, original course structure, learning guides, exercises, datasets created for the series, reference materials, screenshots, written explanations, validation resources, and other original materials are protected by applicable copyright and intellectual-property law.

Third-party product names, trademarks, logos, and services remain the property of their respective owners.

Microsoft, Power BI, Excel, SQL Server, and other Microsoft product names are trademarks or registered trademarks of Microsoft Corporation. SunnyVerse AI Labs is not affiliated with, sponsored by, or endorsed by Microsoft unless expressly stated otherwise.

---

## Educational Disclaimer

The materials are provided for educational purposes. They are not a guarantee of certification success, employment, production suitability, regulatory compliance, or fitness for a specific business environment.

Always validate architecture, security, governance, data-protection, licensing, and deployment decisions against the requirements of the environment in which you are working.

---

## License

Use of this repository is governed by the **SunnyVerse AI Labs Personal Educational Use License** in [LICENSE.md](./LICENSE.md).

This repository is **not open source** and is **not released under MIT, Apache, GPL, Creative Commons, or another standard open-content license** unless a particular third-party file explicitly states otherwise.

If you want to use SunnyVerse materials for teaching, organizational training, publication, redistribution, commercial use, translation, adaptation, or another use outside individual personal learning, you must obtain prior written permission from SunnyVerse AI Labs.

---

**SunnyVerse AI Labs**  
**Power BI Master Series**  
Applied Business Intelligence • Data • Analytics • Enterprise Power BI  

Permissions and licensing inquiries: **sunnyverse10@gmail.com**
