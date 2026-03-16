# Spec-Driven Reconstruction Workflow (SDRW)

Ce workflow définit la méthodologie de reconstruction de Capture One 16.7, pilotée par les spécifications et gérée via Notion. Il remplace et étend les concepts de Conductor pour une intégration directe avec le système de Sprints et Tickets.

## 1. Structure de Données Notion

### Sprints Database (`6360db11...`)
- **Rôle** : Définition des cycles de développement (ex: "Sprint 1 — ROI & Tuilage").
- **Propriétés Clés** : Name, Status, Timeline, Issues (Relation).

### Tickets Database (`b970db11...`)
- **Rôle** : Unités de travail atomiques et techniques.
- **Propriétés Clés** : Issue (Title), ID (Unique ID), Type, Priority, Status, Sprints (Relation).
- **Contenu Obligatoire** :
  - **Demande** : Spécifications brutes et objectifs fonctionnels.
  - **Plan** : Étapes techniques, fichiers impactés, et symboles `RawDumps/` cibles.

## 2. Cycle de Vie d'une Task

### Phase A : Ingestion & Planning
1. **Extraction** : Analyser les sources (User Guide, YouTube transcripts, Headers).
2. **Ticket Creation** : Créer le ticket dans Notion avec la section **Demande**.
3. **Strategy** : Entrer en `plan_mode`, rédiger le **Plan** technique dans le ticket Notion et passer le statut à `In Progress`.
4. **Validation (Mode Normal)** : Demander l'approbation du plan à l'utilisateur.
5. **Autonomie (Mode Loop)** : Exécuter le plan sans validation intermédiaire (sauf doute majeur).
6. **Sprint Linking** : Associer le ticket au sprint actif.
7. **ID Generation** : Notion génère automatiquement l'ID (ex: `ID-11`).

### Phase B : Exécution
1. **Delegation (Mode Loop)** : Utiliser l'agent `generalist` pour gérer l'itération technique (Act -> Validate). Le sub-agent reçoit le Plan et les fichiers sources.
2. **Implementation (Mode Normal)** : Appliquer les modifications chirurgicales dans `src/Sources/`.
3. **Validation Locale** : Build (`swift build`) et tests unitaires si applicables.
4. **Fidelity Sync** : Vérifier la conformité visuelle via `openc1-spec-manager`.

### Phase C : Finalisation & Revue
1. **Commits** : Un ou plusieurs commits atomiques incluant l'ID (ex: `feat(engine): [ID-11] implement tile provider logic`).
2. **Per-Ticket Review** : Appel à `@codebase_investigator` pour évaluer la fidélité et la parité originale.
    - *Fast-Fix* : Correction immédiate des défauts mineurs remontés.
    - *Heavy-Fix* : Création de tickets correctifs si refonte majeure nécessaire.
3. **Resolution Notes** : Renseigner le champ `Resolution Notes` dans Notion.
4. **Notion Sync** : Passer le statut à `Resolved` une fois le ticket complété.
5. **Next Step** : En Mode Loop, passer au ticket suivant. Demander validation uniquement en fin de Sprint.
6. **Registry Update** : Mettre à jour l'historique des features dans `src/docs/feature_history.md`.

## 3. Hiérarchie de Vérité (Source of Truth)
1. **RawDumps/** : La logique binaire et les structures de données originales (Le "Comment").
2. **Notion Tickets** : Les instructions de reconstruction et le plan validé (Le "Quoi").
3. **Global Specs Database** : Les références visuelles et comportementales UI (Le "Look").
4. **src/Sources/** : L'implémentation reconstruite finale.
