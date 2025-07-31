# ChessTrainer - Instructions de Développement

## 🎯 Vision du Projet

Application ultra-gamifiée d'apprentissage des ouvertures ### Conventions de Code

### Architecture Détaillée Implémentée

#### Structure des Modules

```text
modules/
├── auth/           # Authentification utilisateur
│   ├── providers/  # Riverpod providers (auth_providers.dart)
│   └── services/   # Services business (auth_service.dart)
├── chess/          # Logique échecs & plateau
│   ├── models/     # États & modèles (chess_state.dart, node.dart)
│   ├── providers/  # Providers chess (chess_providers.dart)
│   └── services/   # Services échecs (chess_service.dart)
├── learn/          # Système apprentissage
│   ├── models/     # États apprentissage (learn_state.dart)
│   ├── providers/  # Providers apprentissage
│   └── services/   # Services coaching
├── opening/        # Gestion ouvertures PGN
│   ├── models/     # Modèles ouvertures (opening.dart, opening_style.dart)
│   ├── providers/  # Providers PGN (opening_pgn_provider.dart)
│   └── services/   # Services PGN (pgn_loader.dart)
└── user/           # Données & progression utilisateur
    ├── models/     # Modèles user (user.dart)
    ├── providers/  # Providers user (user_providers.dart)
    └── services/   # Services user (user_service.dart)
```

#### Structure des Pages

```text
pages/
├── auth/           # Pages authentification
│   └── auth_wrapper.dart
├── examples/       # Pages développement/tests
│   ├── chessground.dart
│   ├── learn_game_page.dart
│   └── normal_game_page.dart
├── home/           # Page principale/accueil
├── learn/          # Pages apprentissage
└── onboarding/     # Pages onboarding
    ├── onboarding_page.dart
    └── welcome_page.dart
```

#### Structure UI

```text
ui/
├── buttons/        # Boutons standardisés
│   ├── action_button.dart
│   ├── outline_button.dart
│   ├── primary_button.dart
│   └── secondary_button.dart
├── chips/          # Sélecteurs en pastilles
├── gamification/   # Composants gamification
│   └── progress_bar.dart
├── layouts/        # Layouts réutilisables
├── theme/          # Thème & styles globaux
└── ui.dart         # Index exports centralisés
```

#### Structure Constants

```text
constants/
├── openings/       # Organisation PGN par ouverture
│   └── vienna_gambit/
│       └── vienna_gambit.dart
├── openings.dart   # Maps chemins PGN globaux
└── routes.dart     # Routes navigation centralisées
```

### Organisation des Donnéeschecs

Transformer l'apprentissage ennuyeux des ouvertures en expérience addictive et fun. Inspiration : Duolingo + Chess.com.

**Public cible** : Joueurs casual-intermédiaires, amateurs passionnés qui veulent s'améliorer de façon engageante (tout âge)

**Ton unique** : Ludique et fun MAIS sérieux dans l'apprentissage. Éviter le ton enfantin ET le côté rébarbatif des cours classiques. Mix parfait entre engagement et pédagogie de qualité.

**Boucle principale** : Choisir ouverture → Apprendre interactivement → Pratiquer sans aide → Gagner récompenses → Répéter

## 🏗️ Architecture Technique

### Structure du Projet

lib/
├── constants/   # Constantes globales (routes, chemins PGN)
├── modules/     # Logique métier + état (Riverpod providers)
├── pages/       # Écrans UI (suit la navigation)
└── ui/          # Composants réutilisables

### Stack Technique

- **Flutter** (dernière version stable)
- **Riverpod 3** (providers manuels, pas de génération de code)
- **SharedPreferences** (stockage local MVP → Firebase plus tard)
- **Firebase** (Auth + Firestore pour versions futures)
- **Hooks** pour la gestion d'état locale
- **dartchess** (logique échecs Lichess)
- **chessground** (affichage plateau Lichess)
- **PGN** stockés dans assets/ pour les ouvertures

### Règles d'Architecture

1. **Un provider = une responsabilité**
2. **Pas de repositories** : Services → données directement
3. **Providers globaux** vs **page-scoped** (auto-dispose)
4. **Structure = navigation** : dossiers miroir de l'app
5. **Séparation stricte** : logique métier ≠ UI
6. **Modules organisés** : models/ + providers/ + services/ par domaine
7. **UI centralisée** : composants exports via ui/ui.dart
8. **Constants séparées** : routes, chemins assets, configurations

## 🎮 Fonctionnalités Cœur

### 1. Système d'Apprentissage

- **Plateau interactif** : tap-to-move, feedback visuel
- **Coach mascotte** : personnage animé qui explique
- **Apprentissage progressif** : ligne par ligne, coup par coup
- **Explications riches** : pourquoi chaque coup compte

### 2. Mode Pratique

- **Sans aide** : utilisateur trouve les coups seul
- **Difficulté adaptive** : réagit aux erreurs intelligemment
- **Scénarios réels** : contre réponses d'adversaires communes

### 3. Gamification

- **Streaks quotidiennes** : maintenir l'élan
- **XP & niveaux** : points apprentissage + bonus perfection
- **Système d'achievements** : débloquer jalons et collectibles
- **Visualisation progrès** : graphiques, pourcentages

### 4. Onboarding

- **Setup rapide** : Elo + style de jeu + engagement quotidien
- **Recommandations intelligentes** : algorithme matche ouverture parfaite
- **Mode invité** : progrès local vs sync cloud

## 🎨 Guidelines UI/UX

### Philosophie Design

- **Game-first** : animations fluides, interactions satisfaisantes
- **Chess-focused** : plateau central, tout supporte l'échiquier
- **Ton équilibré** : ludique sans être enfantin, sérieux sans être rébarbatif
- **Qualité pédagogique** : explications claires, progression logique
- **Engagement adulte** : respect de l'intelligence du joueur
- **Progressif** : montrer complexité graduellement

### Composants Clés

- Plateau d'échecs avec animations fluides des pièces
- Mascotte coach avec personnalité et animations contextuelles
- Indicateurs de progrès gratifiants à remplir
- Célébrations d'achievements (confettis, effets sonores)

## 🚀 Stratégie d'Implémentation

### MVP (Phase 1)

1. ✅ **Logique échecs de base** : dartchess + chessground intégrés
2. ✅ **Plateau fonctionnel** : coups jouables, affichage Lichess
3. ✅ **Providers chess & learning** : suivi de ligne + coach basique
4. ✅ **Données ouvertures** : PGN stockés dans assets/
5. ✅ **Architecture modulaire** : modules/, pages/, ui/, constants/
6. ✅ **Modèles d'état** : ChessState, LearnState avec copyWith
7. ✅ **Services séparés** : logique métier dans services/
8. ✅ **UI componentisée** : boutons, layouts, gamification
9. 🔄 **Stockage données user local** : progrès, préférences, état apprentissage
10. 🔄 **Flow d'apprentissage affiné** : interaction coach + explications
11. 🔄 **UI learning page** : plateau + panneaux explications

### Phases d'Amélioration

1. **MVP Stockage Local** : SharedPreferences, mode hors-ligne complet
2. **Logique métier complète** : système progrès, persistance robuste
3. **Migration Firebase** : Auth + sync cloud, conservation interface
4. **UI/UX polish** : design, animations, interactions fluides
5. **Gamification** : streaks, XP, achievements
6. **Bibliothèque ouvertures** : expansion multiple ouvertures
7. **Mode pratique** : test connaissances sans indices
8. **Onboarding** : personnalisation et recommandations
9. **Polish avancé** : sons, effets, fonctionnalités premium

## 📊 Métriques de Succès

### Engagement Utilisateur

- Maintien streaks quotidiennes
- Lignes complétées par session
- Taux de retour après première semaine

### Efficacité Apprentissage

- Amélioration précision dans le temps
- Rétention connaissances (succès mode pratique)
- Variété ouvertures explorées

## 📝 Conventions de Code

### Organisation des Données

- **PGN par ligne** : `assets/openings/[opening_name]/[opening_name]_[line_number].pgn`
- **Chemins dans constants** : Maps simples dans `constants/openings.dart`
- **Parsing PGN** : utiliser dartchess directement
- **Structure exemple** : `assets/openings/vienna_gambit/vienna_gambit_1.pgn`
- **Stockage local MVP** : SharedPreferences pour progrès/préférences
- **Architecture upgradable** : interface abstraite → implémentation SharedPref/Firebase

### Organisation du Code

- **Noms descriptifs** plutôt qu'abréviations
- **Patterns cohérents** à travers composants similaires
- **Commentaires** pour logique spécifique échecs
- **Performance** : 60fps interactions plateau

### Providers Riverpod

```dart
// Global (app-wide)
final globalUserProvider = Provider<User>((ref) => ...);

// Page-scoped (auto-dispose)
final pageSpecificProvider = Provider.autoDispose<State>((ref) => ...);
```

## 🎪 Objectif : Rendre Magique

Faire que l'apprentissage des ouvertures ressemble à jouer à un super jeu mobile. Chaque interaction fluide, chaque achievement mérité, chaque leçon donne envie d'apprendre "juste une ligne de plus".

---

## 🤖 Pour l'IA Future

### Quand vous aidez sur ce projet

1. **TOUJOURS** suivre l'architecture modules/pages/ui
2. **PRIORITÉ** à l'expérience utilisateur et la fluidité
3. **SIMPLIFIER** avant de complexifier
4. **TESTER** l'expérience chess au centre de tout
5. **ITÉRER** rapidement, pas de sur-engineering

### Questions à poser si pas clair

- Quelle fonctionnalité spécifique développer ?
- MVP ou fonctionnalité avancée ?
- Pour quel niveau de joueur (casual/intermédiaire) ?
- Priorité performance vs fonctionnalités ?
- Ton ludique ou pédagogique pour cette feature ?

### Ton & Communication pour l'IA

- **Éviter** : ton enfantin, explications condescendantes, gamification excessive
- **Préférer** : ton engageant mais respectueux, explications claires et complètes
- **Objectif** : faire sentir l'utilisateur intelligent tout en s'amusant
- **Style** : professionnel décontracté, motivant sans être excessif

**Principe de base** : Architecture simple → itération rapide → features que les users adorent
