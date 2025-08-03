# DiaryX Development Plan

## Project Overview

DiaryX is a private, offline-first diary application with AI-powered features for voice, text, and visual content capture and intelligent organization.

**Total Estimated Timeline: 17-24 weeks (4.5-6 months)**

---

## Phase 1: Architecture Setup (1-2 weeks)

**Note: Before running any Flutter dependency commands, run the `proxy` command for local machine setup.**

### Project Structure & Architecture

- [x] Implement simple MVC-like folder structure (models, stores, screens, services, utils, widgets, themes, consts)
- [x] Set up Provider + ChangeNotifier for state management
- [x] Set up basic routing configuration
- [x] Initialize main.dart with MultiProvider setup

### Database Foundation

- [x] Set up Drift database with all required tables
- [x] Create database service singleton
- [x] Implement basic CRUD operations

---

## Phase 2: UI Foundation (1-2 weeks)

### Design System

- [x] Implement design system (colors, typography, spacing)
- [x] Create theme management (light/dark mode)
- [x] Set up themes folder structure (app_theme.dart, app_colors.dart, text_styles.dart)
- [x] Create reusable UI components in widgets folder

### Navigation & Core UI

- [x] Implement navigation system and routes
- [x] Create main app structure with bottom navigation
- [x] Set up basic screen templates
- [x] Add loading states and error handling UI

---

## Phase 3: Authentication & Basic Moment Creation (2-3 weeks)

### Authentication

- [x] Implement numeric password authentication
- [x] Set up secure storage for password
- [x] Create password setup and validation screens
- [x] Add basic retry limitation mechanism

### Text Moment System

- [ ] Create text input screen with editor
- [ ] Implement auto-save functionality
- [ ] Add moment creation and editing
- [ ] Set up basic moment storage and retrieval
- [ ] Create simple moment list view

---

## Phase 4: Multimedia Support (2-3 weeks)

### Audio Recording

- [ ] Integrate flutter_sound for voice recording
- [ ] Implement recording UI with waveform visualization
- [ ] Add audio playback functionality
- [ ] Set up audio file storage and management

### Camera Integration

- [ ] Implement photo capture functionality
- [ ] Add video recording (up to 5 minutes)
- [ ] Set up image/video compression
- [ ] Create media preview and selection UI
- [ ] Implement gallery access for existing media

---

## Phase 5: Content Organization (2 weeks)

### Timeline & Calendar Views

- [ ] Create infinite scroll timeline interface
- [ ] Implement calendar month/week views
- [ ] Add content type indicators and thumbnails
- [ ] Create moment cards with preview content
- [ ] Add pull-to-refresh functionality

### Organization Features

- [ ] Implement manual tag system
- [ ] Create mood selection interface
- [ ] Add filtering options (date, content type, mood)
- [ ] Implement sorting functionality
- [ ] Create search bar (basic text search)

---

## Phase 6: AI Integration (3-4 weeks)

### LLM Service Setup

- [ ] Create abstract LLM service interface
- [ ] Implement Gemma 3n integration
- [ ] Set up Ollama API compatibility
- [ ] Create mock AI service for testing
- [ ] Add configuration for local vs remote AI

### Core AI Features

- [ ] Implement speech-to-text processing
- [ ] Add text enhancement and expansion
- [ ] Create text summarization feature
- [ ] Implement basic emotion analysis
- [ ] Set up asynchronous processing queue

### Processing Management

- [ ] Create background task queue system
- [ ] Implement priority-based processing
- [ ] Add processing status indicators
- [ ] Set up error handling and retry logic
- [ ] Add progress notifications

---

## Phase 7: Intelligent Search (2-3 weeks)

### Vector Database

- [ ] Integrate Chroma vector database
- [ ] Set up embedding generation pipeline
- [ ] Implement vector storage for all content types
- [ ] Create embedding update system

### Semantic Search

- [ ] Implement vector similarity search
- [ ] Create search result ranking algorithm
- [ ] Add contextual search with filters
- [ ] Implement search result summarization
- [ ] Create AI chatbot interface for conversational search

---

## Phase 8: Analytics & Insights (2 weeks)

### Data Visualization

- [ ] Integrate fl_chart for data visualization
- [ ] Create mood trend charts and heat maps
- [ ] Implement writing frequency statistics
- [ ] Add content type distribution charts
- [ ] Create emotional word clouds

### Personal Dashboard

- [ ] Build analytics dashboard screen
- [ ] Implement personal insights display
- [ ] Add weekly/monthly summaries
- [ ] Create LLM analysis interface
- [ ] Set up recurring pattern detection

---

## Phase 9: Polish & Optimization (2-3 weeks)

### Performance Optimization

- [ ] Optimize database queries and indexing
- [ ] Implement efficient image/video loading
- [ ] Add lazy loading for timeline
- [ ] Optimize AI processing performance
- [ ] Implement proper memory management

### UI/UX Enhancement

- [ ] Add smooth animations and transitions
- [ ] Implement glass morphism effects
- [ ] Polish micro-interactions
- [ ] Add haptic feedback
- [ ] Create loading states and skeleton screens

### Error Handling

- [ ] Implement comprehensive error handling
- [ ] Add user-friendly error messages
- [ ] Create offline/online state management
- [ ] Add data validation and sanitization
- [ ] Implement crash reporting

---

## Phase 10: Testing & Deployment (1-2 weeks)

### Quality Assurance

- [ ] Conduct comprehensive feature testing
- [ ] Test edge cases and error scenarios
- [ ] Perform performance and memory testing
- [ ] Test on different device sizes and OS versions
- [ ] Validate AI processing accuracy

### Release Preparation

- [ ] Set up build configurations for release
- [ ] Create app icons and splash screens
- [ ] Prepare app store metadata and screenshots
- [ ] Write user documentation and help content
- [ ] Create onboarding tutorial screens

### Final Polish

- [ ] Fix any remaining bugs and issues
- [ ] Optimize app size and startup time
- [ ] Validate privacy and security measures
- [ ] Prepare for app store submission
- [ ] Create backup and data export features

---

## Key Milestones

- **Week 2**: Architecture setup and database foundation complete
- **Week 4**: UI foundation and authentication ready
- **Week 7**: Text moments and multimedia capture working
- **Week 9**: Content organization and basic UI complete
- **Week 13**: AI features integrated and functional
- **Week 16**: Smart search and analytics implemented
- **Week 19**: App polished and ready for testing
- **Week 22**: Released to app stores

## Technical Dependencies

- Flutter 3.32.8 with Dart SDK
- Drift for local database
- Chroma for vector storage
- Gemma 3n for local AI processing
- Standard Flutter packages for camera, audio, charts

## Success Criteria

- [ ] Fully offline functionality
- [ ] Smooth 60fps performance
- [ ] AI processing under 30 seconds
- [ ] Intuitive user experience
- [ ] Stable and crash-free operation
