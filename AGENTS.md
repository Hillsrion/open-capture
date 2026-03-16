# Agent Systems & Workflows

Ce projet utilise des agents IA spécialisés pour la reconstruction de Capture One 16.7. Ce fichier répertorie les systèmes opérationnels et les guides de workflow.

## 🚀 Workflows Actifs

### 1. Spec-Driven Reconstruction Workflow (SDRW)
- **Localisation** : `src/docs/spec_driven_workflow.md`
- **Description** : Workflow principal piloté par Notion (Sprints/Tickets) et les données décompilées (`RawDumps/`).
- **Agents** : `c1-backlog-executor`, `c1-ticket-creator`.

### 2. Conductor (Legacy/Registry)
- **Localisation** : `conductor/index.md`
- **Description** : Système de gestion de tracks et de specs locales utilisé pour la planification initiale de l'architecture.

## 🛠 Skills Spécialisés (`skills/`)

- **c1-backlog-executor** : Exécution de tickets Notion.
- **c1-ticket-creator** : Création et planification de tickets selon le SDRW.
- **c1-doc-spec-extractor** : Extraction de specs depuis la documentation officielle.
- **openc1-spec-manager** : Gestion des assets visuels (frames/transcripts) et synchronisation Notion.

## 📋 Références Notion
- **Sprints** : `6360db11-ba37-82bb-bc58-81e475e8da56`
- **Tickets** : `b970db11-ba37-8351-bf14-01025baf506e`
- **Global Specs** : `3200db11-ba37-819a-9122-c59d20dedc49`
