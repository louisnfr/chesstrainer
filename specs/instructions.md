# Chess Openings Learning App - Development Instructions

## 🎯 Project Vision

**Ultra-gamified chess openings learning app** that transforms boring memorization into an engaging, fun experience. Think Duolingo meets Chess.com - interactive lessons, streaks, achievements, and a friendly coach mascot that makes learning addictive.

**Core Loop**: Choose opening → Learn interactively → Practice without help → Earn rewards → Repeat

## 🏗️ Architecture Philosophy

lib/
├── modules/     # Business logic & state
├── pages/       # UI following navigation structure
└── ui/          # Reusable components

### Key Principles

- **Riverpod 3** (manual providers, no code generation)
- **Firebase**
- **Single responsibility**: One provider per concern
- **No repositories**: Services talk directly to data, providers hold state
- **Global vs Page-scoped**: Providers are either app-wide or page-specific
- **Navigation-based structure**: Folder structure mirrors app navigation
- **Separation of concerns**: Business logic 100% separate from UI

## 🎮 Core Features

### Onboarding & Personalization

- **Quick setup**: Elo + playing style + daily commitment
- **Smart recommendations**: Algorithm matches user to perfect opening
- **Guest mode**: Local progress vs cloud sync

### Learning System

- **Interactive board**: Tap-to-move, visual feedback
- **Coach mascot**: Animated character explaining each move
- **Progressive disclosure**: Learn line by line, move by move
- **Rich explanations**: Why each move matters strategically

### Practice Mode

- **No training wheels**: User must find correct moves alone
- **Adaptive difficulty**: Responds to user mistakes intelligently
- **Real scenarios**: Practice against common opponent responses

### Gamification Engine

- **Daily streaks**: Maintain momentum with commitment tracking
- **XP & levels**: Points for learning, bonuses for perfection
- **Achievement system**: Unlock milestones and collectibles
- **Progress visualization**: Charts, percentages, completion stats

## 🎨 UI Guidelines

### Design Philosophy

- **Game-first**: Smooth animations, satisfying interactions
- **Chess-focused**: Board is central, everything else supports it
- **Friendly & encouraging**: Warm colors, positive messaging
- **Progressive**: Show complexity gradually, not overwhelming

### Component Strategy

- **Reusable widgets** in `ui/` folder for common elements
- **Feature-specific widgets** stay in page folders
- **Lift widgets** to `ui/` only when reused across pages
- **Design system** with consistent colors, typography, spacing

### Key UI Components

- Interactive chess board with smooth piece animations
- Coach mascot with personality and contextual animations
- Progress indicators that feel rewarding to fill
- Achievement celebrations (confetti, sound effects)

## 🚀 Implementation Strategy

### MVP Scope

1. **Core chess logic**: Board, moves, basic validation
2. **Single opening**: One complete opening with multiple lines
3. **Basic learning flow**: Interactive lessons without gamification
4. **Simple UI**: Functional board + move explanations

### Enhancement Phases

1. **Gamification**: Add streaks, XP, achievements
2. **Multiple openings**: Expand opening library
3. **Practice mode**: Test knowledge without hints
4. **Onboarding**: Personalization and recommendations
5. **Polish**: Animations, sounds, advanced features

### Development Philosophy

- **Start simple**: Get core experience working first
- **Iterate fast**: Playtest early, adjust based on user feel
- **Focus on fun**: Gamification should feel rewarding, not grindy
- **Performance matters**: Smooth 60fps chess board interactions

## 🎯 Key Success Metrics

### User Engagement

- Daily streak maintenance
- Lines completed per session
- Return rate after first week
- Time spent in learning vs practice modes

### Learning Effectiveness

- Accuracy improvement over time
- Knowledge retention (practice mode success)
- Opening variety explored
- Real game application

## 📝 Code Style & Conventions

### Architecture Rules

- **Feature-based modules**: Business logic organized by domain
- **Navigation-based pages**: UI structure mirrors app flow
- **Provider scoping**: Global for shared state, auto-dispose for page-specific
- **Service as singleton**: One instance per service type

### Naming & Organization

- Descriptive names over abbreviations
- Consistent patterns across similar components
- Clear separation between data, logic, and presentation
- Comments for chess-specific logic and algorithms

### Performance Guidelines

- **Efficient rebuilds**: Watch specific providers, not entire state trees
- **Lazy loading**: Load opening data as needed
- **Animation performance**: Use appropriate widgets for smooth interactions
- **Memory management**: Auto-dispose providers when pages close

## 🎪 Make It Feel Magical

The goal is to make learning chess openings feel like playing a great mobile game. Every interaction should be smooth, every achievement should feel earned, and every lesson should leave users wanting to learn just one more line.

**Remember**: The best architecture is one that lets you iterate quickly and build features that users love. Keep it simple, keep it fun, and focus on the core experience of making chess learning addictive.
