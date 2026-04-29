# Digital Tasbeeh - Navigation Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    Counter Screen (Home)                     │
│  ┌────────────────────────────────────────────────────────┐ │
│  │  [Menu]                                   [No Ads]      │ │
│  │                                                          │ │
│  │              [HAPTICS]    [SOUND]                        │ │
│  │                                                          │ │
│  │               سُبْحَانَ اللّهِ                          │ │
│  │               SubhanAllah                                │ │
│  │            Glory be to Allah                             │ │
│  │                                                          │ │
│  │                  ┌──────────┐                            │ │
│  │                  │   0033   │                            │ │
│  │                  │  COUNT   │                            │ │
│  │                  └──────────┘                            │ │
│  │                                                          │ │
│  │          Tap anywhere on the circle                      │ │
│  │                                                          │ │
│  │    [Save]        [Reset]       [Settings]                │ │
│  └────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────┘
                      │              │              │
         ┌────────────┘              │              └────────────┐
         ▼                           ▼                           ▼
┌──────────────────┐      ┌──────────────────┐      ┌──────────────────┐
│  My Dhikrs       │      │  Prayer          │      │  Settings        │
│  Screen          │      │  Sequence        │      │  Screen          │
│                  │      │  Screen          │      │                  │
│  • List all      │      │                  │      │  • Vibration     │
│    dhikrs        │      │  Step 1 of 3     │      │  • Mute          │
│  • Progress      │      │  33% Complete    │      │  • Language      │
│    indicators    │      │                  │      │  • Theme         │
│  • Edit/Delete   │      │  SubhanAllah     │      │  • Rate App      │
│  • [+ Add]       │      │     (33/33)      │      │  • Share App     │
│                  │      │                  │      │  • Other Apps    │
│  [Empty State]   │      │  [Next Dhikr]    │      │                  │
└──────────────────┘      └──────────────────┘      └──────────────────┘
         │
         ▼
┌──────────────────┐
│  Add/Edit        │
│  Dhikr Screen    │
│                  │
│  • Name*         │
│  • Description   │
│  • Current Count │
│  • Set Target    │
│    ├─ Target #   │
│                  │
│  [Save Dhikr]    │
└──────────────────┘
```

## Screen Navigation Details

### 1. Counter Screen → My Dhikrs Screen
- **Trigger**: Tap menu icon (top left)
- **Action**: Opens list of all saved dhikrs
- **Return**: Select a dhikr to return to counter with that dhikr active

### 2. Counter Screen → Settings Screen
- **Trigger**: Tap settings icon (bottom right)
- **Action**: Opens settings page
- **Return**: Back button returns to counter

### 3. My Dhikrs Screen → Add Dhikr Screen
- **Trigger**: Tap floating action button (+)
- **Action**: Opens form to create new dhikr
- **Return**: Save creates dhikr and returns, X button cancels

### 4. My Dhikrs Screen → Edit Dhikr Screen
- **Trigger**: Tap edit icon on any dhikr card
- **Action**: Opens pre-filled form for editing
- **Return**: Update saves changes and returns

### 5. My Dhikrs Screen → Prayer Sequence Screen
- **Trigger**: Auto-navigation when dhikrs with targets exist
- **Action**: Guides through traditional post-prayer sequence
- **Return**: Complete button returns to main counter

## Data Flow

```
┌─────────────────────────────────────────────────────┐
│                  SharedPreferences                  │
│  ┌────────────────────────────────────────────────┐ │
│  │  Key: 'dhikrs'                                  │ │
│  │  Value: JSON array of all dhikrs               │ │
│  │                                                 │ │
│  │  Key: 'settings'                                │ │
│  │  Value: JSON object with user preferences      │ │
│  │                                                 │ │
│  │  Key: 'current_dhikr'                           │ │
│  │  Value: ID of currently selected dhikr         │ │
│  └────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────┘
                            │
                ┌───────────┴───────────┐
                ▼                       ▼
        ┌───────────────┐       ┌───────────────┐
        │ StorageService│       │ Dhikr Model   │
        │               │       │               │
        │ • loadDhikrs()│       │ • id          │
        │ • saveDhikr() │       │ • name        │
        │ • loadSettings│       │ • description │
        │ • saveSettings│       │ • currentCount│
        └───────────────┘       │ • targetCount │
                                │ • hasTarget   │
                                │ • icon        │
                                │ • isCompleted │
                                └───────────────┘
```

## User Journey Examples

### Scenario 1: First Time User
1. App opens with default SubhanAllah dhikr (count: 0, target: 33)
2. User taps circle 33 times → Counter increments with haptic feedback
3. Dhikr marked complete when target reached
4. User can reset or navigate to My Dhikrs to add more

### Scenario 2: Adding Custom Dhikr
1. From Counter screen → Tap menu icon
2. In My Dhikrs → Tap + button
3. Enter name: "Istighfar"
4. Enter description: "Seeking forgiveness"
5. Set current count: 0
6. Enable target toggle → Set target: 100
7. Tap Save → Returns to My Dhikrs with new dhikr in list
8. Select new dhikr → Returns to Counter with Istighfar active

### Scenario 3: Prayer Sequence Mode
1. User has dhikrs with targets (SubhanAllah, Alhamdulillah, Allahu Akbar)
2. Navigate to Prayer Sequence from menu
3. Complete SubhanAllah (33 counts) → Auto advances to next
4. Complete Alhamdulillah (33 counts) → Auto advances to next
5. Complete Allahu Akbar (34 counts) → Shows completion
6. Tap Complete → Returns to main counter

### Scenario 4: Customizing Settings
1. From Counter screen → Tap settings icon
2. Toggle vibration ON/OFF
3. Toggle mute to disable sounds
4. Change language from Eng to اردو
5. Back button → Returns to counter with new settings applied

## State Management

Each screen manages its own state using StatefulWidget:

- **Counter Screen**: Tracks current dhikr, count, and settings
- **My Dhikrs Screen**: Manages list of dhikrs and loading state
- **Add Dhikr Screen**: Manages form inputs and validation
- **Prayer Sequence Screen**: Tracks current step and progress
- **Settings Screen**: Manages preference toggles

All data persists through StorageService using SharedPreferences.
