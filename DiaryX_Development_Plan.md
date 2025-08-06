# DiaryX Development Plan

## Project Overview

DiaryX is a private, offline-first diary application with AI-powered features for voice, text, and visual content capture and intelligent organization.

**Total Estimated Timeline: 17-23 weeks (4.5-6 months)**

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

- [x] Create text input screen with editor
- [x] Implement auto-save functionality
- [x] Add moment creation and editing
- [x] Set up basic moment storage and retrieval
- [x] Create simple moment list view

---

## Phase 4: Multimedia Support (2-3 weeks)

### Audio Recording

- [x] Integrate record package for voice recording
- [x] Implement recording UI with waveform visualization
- [x] Add audio playback functionality
- [x] Set up audio file storage and management

### Camera Integration

- [x] Implement photo capture functionality
- [x] Add video recording (up to 5 minutes)
- [x] Set up image/video compression
- [x] Create media preview and selection UI
- [x] Implement gallery access for existing media

---

## Phase 5: Content Organization (2 weeks)

### Timeline & Calendar Views

- [x] Create infinite scroll timeline interface
- [x] Implement calendar month/week views
- [x] Create moment cards with preview content
- [x] Add pull-to-refresh functionality

---

## Phase 6: AI Integration (3-4 weeks)

### LLM Engine Setup

- [x] Create abstract LLM engine interface
- [x] Implement clean AI engine architecture with proper separation
- [x] Set up Ollama API compatibility
- [x] Create mock AI engine for testing
- [x] Add configuration for local vs remote AI
- [x] Implement cancellation token support for all AI operations

### Core AI Features

- [x] Implement speech-to-text processing with cancellation support
- [x] Add streaming text enhancement and expansion
- [x] Create text summarization feature with cancellation
- [x] Implement mood analysis with cancellation support
- [x] Add tag generation with cancellation support
- [x] Set up vector embedding generation
- [x] Implement streaming chat completion for conversational AI

### AI Engine Architecture Optimization

- [x] Reorganize AI engine folder structure (models/, configs/, implementations/)
- [x] Create unified models directory for all AI-related data structures
- [x] Implement structured AIEngineConfig and AIEngineStatus classes
- [x] Add comprehensive cancellation token support across all methods
- [x] Clean up legacy code and deprecated methods
- [x] Update all code comments to American English

### Universal Task Queue System

- [x] Design and implement generic, decoupled task queue system
- [x] Create abstract TaskQueue interface with memory and database implementations
- [x] Implement TaskService as singleton with handler registration
- [x] Add task prioritization, retry logic, and status tracking
- [x] Separate task queue completely from AI engine (moved to lib/services/task/)
- [x] Implement database-backed persistent task queue
- [x] Add comprehensive task statistics and monitoring

---

## Phase 7: Chat System Implementation (2-3 weeks)

### Database Extensions

- [x] Create Chats table for chat session management
- [x] Create ChatMessages table for individual chat messages
- [x] Add database migration for new chat-related tables
- [x] Implement chat CRUD operations in database service

### Chat UI/UX Implementation

- [x] Implement chat list screen with session management
- [x] Create chat conversation screen with message display
- [x] Integrate gpt_markdown package for Markdown rendering (fully implemented with GptMarkdown component)
- [x] Design glass morphism message bubbles with modern styling
- [x] Implement responsive chat input with image attachment support (input ready, picker pending)
- [x] Add streaming message display with typewriter effects (simplified, direct markdown rendering)

### Chat Functionality

- [x] Implement new chat creation functionality
- [x] Add chat session persistence and loading
- [x] Create chat title generation from first message
- [x] Implement message sending with text and image support
- [x] Add streaming AI response with cancellation support
- [x] Integrate existing AIService chat interface

### Navigation & Route Updates

- [x] Update search tab to chat tab with star icon
- [x] Modify route from '/search' to '/chat'
- [x] Update bottom navigation configuration
- [x] Implement navigation between chat list and conversation screens

### State Management

- [x] Create ChatStore for chat state management
- [x] Implement chat message real-time updates
- [x] Add streaming message state handling
- [x] Create chat session management logic

### Dependencies & Packages

- [x] Add gpt_markdown package for Markdown rendering
- [x] Add image_picker package for image attachments
- [x] Update pubspec.yaml with required dependencies
- [x] Configure package permissions for image selection

---

## Phase 8: Analytics & Insights (2 weeks)

### Data Visualization

- [ ] Integrate fl_chart for data visualization
- [ ] Create mood trend charts and heat maps
- [ ] Implement writing frequency statistics
- [ ] Add content type distribution charts
- [ ] Create mood word clouds

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
- **Week 13**: AI features integrated and functional with optimized engine architecture and universal task queue
- **Week 16**: Chat system implemented with modern UI/UX and streaming capabilities
- **Week 18**: Analytics and insights implemented
- **Week 21**: App polished and ready for testing
- **Week 23**: Released to app stores

## Technical Dependencies

- Flutter 3.32.8 with Dart SDK
- Drift for local database with optimized task queue schema and chat tables
- Gemma 3n for local AI processing with cancellation support
- Universal task queue system for background processing
- gpt_markdown package for advanced Markdown rendering
- image_picker for chat image attachments
- Standard Flutter packages for camera, audio, charts

## Success Criteria

- [ ] Fully offline functionality
- [ ] Smooth 60fps performance
- [ ] AI processing under 30 seconds
- [ ] Intuitive user experience
- [ ] Stable and crash-free operation
