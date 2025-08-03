# DiaryX Product Design Document

## 1. Product Overview

### 1.1 Product Vision

DiaryX is a private, offline-first diary application that empowers users to quickly capture their thoughts, experiences, and memories through multiple input methods (voice, text, images/videos). Leveraging local LLM capabilities, it intelligently assists users in recording, expanding, summarizing, searching, and categorizing their diary moments.

### 1.2 Core Values

- **Privacy First**: Complete offline functionality
- **Simplicity**: Intuitive interactions that require zero learning curve
- **Intelligence**: AI-powered content enhancement and smart search capabilities
- **Accessibility**: Multiple input methods to accommodate different user preferences
- **Aesthetic**: Modern, premium design with smooth animations and glass morphism effects

### 1.3 Target Users

- **Primary**: Global users of all ages who value privacy and personal reflection
- **Secondary**: Users seeking AI-assisted journaling and content organization
- **Tertiary**: Users transitioning from traditional paper diaries to digital solutions

## 2. User Scenarios and Use Cases

### 2.1 Primary Use Cases

1. **Quick Memory Capture**: User wants to instantly record a thought during commute
2. **Detailed Reflection**: User sits down for a comprehensive daily journal session
3. **Memory Retrieval**: User searches for past experiences or specific events
4. **Mood Tracking**: User wants to understand mood patterns over time
5. **Visual Storytelling**: User captures moments through photos and videos with context

### 2.2 User Journey Maps

#### First-Time User Journey

1. Download & Install → Security Setup → Onboarding → First Moment Creation → AI Feature Discovery
2. **Pain Points Addressed**: Unclear functionality, complex setup, overwhelming features
3. **Delight Moments**: Smooth voice recording, beautiful UI, instant AI assistance

#### Daily User Journey

1. App Launch → Quick Authentication → Capture Method Selection → Content Creation → AI Enhancement → Save & Organize
2. **Pain Points Addressed**: Slow access, limited input methods, poor organization
3. **Delight Moments**: Lightning-fast moment creation, smart categorization, beautiful timeline view

## 3. Functional Requirements

### 3.1 Core Features

#### 3.1.1 Multi-Modal Input System

**Voice Recording**

- One-tap voice recording with visual waveform
- Async speech-to-text conversion via Gemma 3n
- Audio compression and storage management

**Text Input**

- Simple text editor for quick note-taking
- Auto-save functionality
- Support for continuous multi-segment recording
- Post-input enhancement options (polish, expand, summarize)

**Visual Content**

- Camera integration for instant photo capture
- Gallery/photo library access
- Video recording capability (up to 5 minutes)
- Image compression with original preservation
- Video thumbnail extraction for AI processing

#### 3.1.2 AI-Powered Features

**Content Enhancement**

- Automatic text summarization
- Content expansion and elaboration suggestions
- Mood analysis (supporting multiple moods per moment)
- Smart tagging and categorization

**Intelligent Search**

- Vector-based semantic search across all content types
- Voice query support
- Image-based search ("Find moments with similar photos")
- Context-aware result ranking
- Search result summarization via LLM

**Processing Queue Management**

- Background processing indicator
- Priority-based queue (user-initiated > automatic)
- Process status visualization
- Error handling and retry mechanisms

### 3.2 Content Organization

#### 3.2.1 Calendar and Timeline Views

**Calendar Interface**

- Month view with daily moment indicators
- Week view for detailed daily breakdown
- Visual indicators for different content types:
  - Photo moments: Small thumbnail overlay
  - Video moments: Play button icon
  - Voice moments: Waveform icon
  - Text moments: Document icon
  - Mixed moments: Multiple icons
- **Mood Indicators**: Color-coded mood indicators for each day (supporting multiple moods per day)
- **Mood Trends**: Visual representation of mood patterns over time

**Timeline Features**

- Chronological scrolling interface
- Filter options: Content type, date range, mood, tags
- Sort options: Date, relevance, AI-analyzed importance
- Infinite scroll with performance optimization
- Preview cards with expandable details

#### 3.2.2 Smart Organization

**Automatic Categorization**

- AI-generated tags based on content analysis
- Mood classification (Happy, Reflective, Anxious, Excited, etc.) - supports multiple moods per moment
- Activity detection (Travel, Work, Relationships, Hobbies, etc.)
- Temporal patterns (Morning thoughts, Evening reflections, etc.)

**Manual Organization**

- Custom tag creation and management
- Manual mood override

### 3.3 Analytics and Insights

#### 3.3.1 Personal Dashboard

**Mood Intelligence Panel**

- Mood trend visualization (line charts, color-coded calendar)
- Mood word cloud from recent moments
- Gratitude and positivity metrics
- Weekly mood summary with AI insights

**Reflection Insights**

- Writing frequency and consistency tracking
- Personal growth themes identification
- Recurring topics and interests analysis
- Memory recall patterns

**Content Statistics**

- Total moments and word count
- Media content overview
- Most active days/times
- Search pattern analysis

#### 3.3.2 Data Visualization

- Mood heat map calendar
- Weekly/monthly trend lines
- Interactive mood wheel
- Tag relationship network
- Content type distribution charts

### 3.4 Simple LLM Analysis

#### 3.4.1 Content Analysis

**Mood Pattern Recognition**

- Automatic mood analysis for each diary moment (supporting multiple moods)
- Mood trend identification over time periods
- Simple sentiment analysis using LLM capabilities

**Content Insights**

- Periodic analysis of recent diary moments (user-initiated)
- LLM-generated insights based on writing patterns
- Simple observations and patterns
- Content summarization and expansion

#### 3.4.2 Streamlined LLM Support

**On-Demand Analysis**

- User can request analysis of recent moments
- LLM provides insights and observations
- Simple, non-intrusive analysis approach

**Basic Analysis Features**

- Gentle observations about writing patterns
- Simple content suggestions when appropriate
- Text expansion and summarization capabilities

## 4. User Interface Design

### 4.1 Design System

#### 4.1.1 Responsive Layout Guidelines

**Flexible Layout Principles**

- **Avoid Fixed Widths/Heights**: Use padding, margins, and flexible containers instead of fixed dimensions
- **Adaptive Components**: Leverage Row, Column, Expanded, Flexible, and Padding widgets for responsive layouts
- **Screen Size Compatibility**: Design components to adapt gracefully across different phone screen sizes
- **Content-Driven Sizing**: Let content determine component sizes with appropriate constraints
- **Spacing System**: Use consistent padding/margin values (8dp, 16dp, 24dp, 32dp) for scalable designs

#### 4.1.2 Color Palette

**Light Theme**

- Primary: #8487E4 (Premium Light Purple)
- Secondary: #A8AAF0 (Soft Purple)
- Background: #FAFBFF (Off-white)
- Surface: #FFFFFF (Pure White)
- Accent: #6366F1 (Vibrant Purple)
- Text Primary: #1F2937 (Dark Gray)
- Text Secondary: #6B7280 (Medium Gray)

**Dark Theme**

- Primary: #5B67D6 (Perfect Purple Blue - Avatar Color)
- Secondary: #7B85E6 (Harmonious Purple)
- Background: #0B0B0F (Ultra Deep Blue Black)
- Surface: #161622 (Deep Blue Gray Surface)
- Accent: #454FA7 (Deep Sophisticated Purple)
- Text Primary: #F8FAFC (Pure White)
- Text Secondary: #CBD5E1 (Soft Gray)

#### 4.1.3 Visual Effects

- **Modern Flat Design**: Clean, minimalist aesthetic with geometric elements
- **Glass Morphism**: Frosted glass cards with backdrop blur effects
- **Gaussian Blur**: Subtle blur effects for depth and focus
- **Gradient Overlays**: Smooth color transitions and gradients
- **Geometric Lines**: Simple vector illustrations using basic geometric shapes
- **Smooth Animations**: Fluid 300-500ms micro-animations throughout the app
- **Floating Elements**: Elevated cards and buttons with subtle shadows
- **Progressive Disclosure**: Clean information hierarchy and reveal patterns

### 4.2 Page Structure and Navigation

#### 4.2.1 App Navigation Architecture

```
Launch Flow:
├── Password Authentication Screen - Numeric password input
└── Capture Interface - Quick moment creation (default moment)

Bottom Tab Navigation:
├── Timeline - Chronological moment view with calendar mode
├── Report - Dashboard and analytics
├── Capture (Add) - Quick moment creation
├── Search - AI-powered search and chatbot interface
└── Profile - Settings and user preferences
```

#### 4.2.2 Detailed Page Specifications

**Password Authentication Screen**

- Clean numeric password input interface
- 4-6 digit password input
- Password error prompts and retry mechanism
- App icon and brand display

**Capture/Add Screen**

- Hero section with three large action buttons:
  - Voice recording (microphone icon with waveform animation)
  - Camera capture (camera icon with viewfinder animation)
  - Text moment (edit icon with typing animation)
- Continuous recording support - users can add multiple moments in one session
- Simple, focused interface for quick capture
- Recent moments preview (2-3 cards)
- Quick mood selector

**Timeline Screen**

- Infinite scroll card layout with calendar mode toggle in header
- Calendar mode: Month/week view with mood indicators
- Timeline mode: Chronological moment view
- Each card includes:
  - Date/time stamp
  - Content preview (text/image/audio waveform)
  - Mood indicator (color-coded circle)
  - Tag chips
  - Expansion/edit actions
- Floating filter button
- Search integration at top
- Pull-to-refresh functionality

**Report Screen**

- Dashboard with analytics and insights
- Key metrics display:
  - Total moments and word count
  - Mood trends and patterns
  - Writing frequency statistics
  - Content type distribution
- LLM analysis button
- Data visualization charts
- Weekly/monthly summaries

**Search Screen**

- Dual interface with toggle between traditional search and AI chatbot
- Traditional search:
  - Prominent search bar with voice input option
  - Multi-select filters (Content Type, Date Range) - default: no filters
  - Recent searches
  - Simple result list with visual cards
- AI Chatbot interface:
  - Chat-like interface for conversational search
  - Pre-built templates and prompts
  - LLM analysis templates
  - Voice input support
  - Context-aware responses

**LLM Analysis Screen**

- Accessible from Report screen via dedicated button
- Clean, simple interface for LLM insights
- "Analyze My Moments" button for on-demand analysis
- Recent analysis results display
- Simple insights and observations
- Content expansion and summarization options

**Profile/Settings Screen**

- Warm, welcoming text with simple geometric illustrations
- No user avatar - focus on personal connection
- Settings sections:
  - Security (numeric password setup)
  - AI preferences (Local model vs Remote API/Ollama)
  - Appearance (theme, text size)
  - About and help

### 4.3 Animation Guidelines

- **Entrance animations**: Slide-up with fade (300ms)
- **Navigation transitions**: Shared element transitions
- **Loading states**: Skeleton screens with pulse animation
- **Voice recording**: Real-time waveform visualization
- **AI processing**: Subtle progress indicators with floating dots
- **Success feedback**: Micro-interactions with haptic feedback

## 5. User Experience Flows

### 5.1 Onboarding Flow

1. **Welcome Screen**: Brand introduction with beautiful geometric illustrations
2. **Input Method Tutorial**: Interactive demonstration of voice/text/camera features
3. **AI Features Overview**: Explanation of intelligent assistance capabilities
4. **First Moment Creation**: Guided creation of inaugural diary moment (can be skipped)
5. **Success Celebration**: Welcome message with encouragement

### 5.2 Daily Moment Creation Flow

1. **Launch App**: Numeric password authentication
2. **Enter Capture Interface**: Direct access to quick recording interface
3. **Choose Input Method**: Voice, camera, or text selection
4. **Content Creation**:
   - Voice: Tap-to-record with visual feedback
   - Camera: Instant capture with preview
   - Text: Simple text editor for quick notes
5. **Continuous Recording**: Support for multiple segments in one session
6. **Post-Input Enhancement** (Optional): Choose to polish, expand, or summarize content
7. **Review and Save**: Final review with metadata addition
8. **Success Feedback**: Gentle confirmation with next action suggestions

### 5.3 Search and Discovery Flow

1. **Search Initiation**: Text, voice, or image-based query
2. **Filter Application** (Optional): Apply content type and date range filters
3. **Processing Indicator**: Visual feedback during search
4. **Results Display**: Simple result list with visual cards
5. **Result Selection**: Preview and full moment viewing
6. **Action Options**: Edit or create similar moment

### 5.4 Asynchronous Processing Flow

#### 5.4.1 Speech-to-Text Processing

1. **Voice Recording Complete**: User completes voice recording
2. **Queue Addition**: Add voice file to asynchronous processing queue
3. **Background Processing**: Use Gemma 3n for speech-to-text conversion
4. **Status Update**: Display processing status in timeline
5. **Result Save**: Save transcription result to database

#### 5.4.2 Image-to-Text Processing

1. **Image Upload Complete**: User completes photo capture or selection
2. **Queue Addition**: Add image file to asynchronous processing queue
3. **Background Processing**: Use Gemma 3n for image content recognition
4. **Status Update**: Display processing status in timeline
5. **Result Save**: Save recognition result to database

#### 5.4.3 Text Expansion Processing

1. **User Request**: User chooses to expand current text
2. **Immediate Processing**: Use Gemma 3n for text expansion
3. **Real-time Display**: Show expansion result to user in real-time
4. **User Confirmation**: User confirms whether to save expansion result

## 6. Edge Cases and Error Handling

### 6.1 Common Edge Cases

- **AI Processing Failures**: Retry mechanisms with user feedback
- **Password Authentication Failures**: Limit retry attempts in short time

### 6.2 Error States

- **Empty States**: Encouraging first-time creation flows
- **Loading Failures**: Retry options with helpful messages
- **Search No Results**: Alternative search suggestions
- **AI Processing Errors**: Fallback to basic functionality

## 7. Content Strategy

### 7.1 Onboarding Content

- **Welcome Messages**: Warm, encouraging tone
- **Tutorial Text**: Clear, concise instructions
- **Placeholder Content**: Inspiring sample moments
- **Tips and Tricks**: Contextual help throughout the app

### 7.2 Empty State Content

- **No Moments**: Motivational prompts to start journaling
- **No Search Results**: Helpful alternative search suggestions
- **Processing Queue Empty**: Encouragement to create more content
- **Calendar Empty**: Gentle reminders about starting the journaling habit

### 7.3 AI-Generated Content

- **Daily Prompts**: Thoughtful questions to inspire writing
- **Content Suggestions**: Expansion ideas based on current moments
- **Summary Text**: Intelligent synthesis of user's thoughts
- **Search Summaries**: Contextual results with extracted insights

### 7.4 Simple LLM Analysis Content

- **Mood Pattern Recognition**: Simple mood analysis based on diary content (supporting multiple moods per moment)
- **Writing Pattern Observations**: Gentle observations about user's writing habits
- **Content Summarization**: Intelligent summarization of diary moments
- **Search Insights**: Simple insights based on search results

This product design document provides the foundation for creating a simple, user-friendly diary application that balances AI capabilities with intuitive design, focusing on core journaling and intelligent assistance features.
