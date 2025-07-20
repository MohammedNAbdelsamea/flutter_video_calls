import 'dart:math';
import 'package:flutter/material.dart';
import 'package:guitare_video_calls/const.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

void main() {
  runApp(VideoCallApp());
}

class VideoCallApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Group Video Call - Test Room',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'SF Pro Display',
      ),
      home: ContactsScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Contact Model
class Contact {
  final String name;
  final String subtitle;
  final String imageUrl;

  Contact({
    required this.name,
    required this.subtitle,
    required this.imageUrl,
  });
}

// Contacts Screen - Exact match to left side of image
class ContactsScreen extends StatelessWidget {
  // Fixed image URLs with proper Unsplash format
  final List<String> favoriteImages = [
    'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    'https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
  ];

  final List<Contact> recentTalks = [
    Contact(
      name: 'Stephanie J. Terry',
      subtitle: '20 mins ago',
      imageUrl: 'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    ),
    Contact(
      name: 'Doyle J. Anderson',
      subtitle: '1 hr ago',
      imageUrl: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    ),
    Contact(
      name: 'Juanita R. Wagner',
      subtitle: '2 hrs ago',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    ),
    Contact(
      name: 'Juanita R. Wagner',
      subtitle: '3 hrs ago',
      imageUrl: 'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    ),
    Contact(
      name: 'Jacqueline Jones',
      subtitle: '5 hrs ago',
      imageUrl: 'https://images.unsplash.com/photo-1544005313-94ddf0286df2?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
    ),
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: secColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with back button and add contact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.arrow_back, color: primColor, size: 20),
                  Text(
                    'CONTACTS',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: primColor,
                      letterSpacing: 1.5,
                    ),
                  ),
                  Icon(Icons.person_add_outlined, color: primColor, size: 24),
                ],
              ),

              SizedBox(height: 25),

              // Search bar
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(Icons.search_rounded, color: Colors.grey[400], size: 20),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search your contacts',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Icon(Icons.mic_none_rounded, color: primColor, size: 20),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Favourite section


              SizedBox(height: 15),

              // Favorite contacts horizontal list
              Container(
                height: 130, // Total height remains 100
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1), // Fixed withOpacity instead of withValues
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10, top: 20, bottom: 2), // Padding for text
                      child:   Text(
                        'FAVOURITE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: primColor,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: favoriteImages.length,
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        itemBuilder: (context, index) {
                          return Container(
                            margin: EdgeInsets.only(right: 10, top: 10, bottom: 5), // Adjusted margins to fit within reduced height
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: 60,
                                height: 60, // Kept height to maintain square shape
                                color: Colors.grey[300],
                                child: Image.network(
                                  favoriteImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: Icon(Icons.person, color: Colors.grey[500]),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20), // Space below the horizontal list
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Recent talks section
              Text(
                'RECENT TALKS',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: primColor,
                  letterSpacing: 1.0,
                ),
              ),

              SizedBox(height: 15),

              // Recent contacts list
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    itemCount: recentTalks.length,
                    itemBuilder: (context, index) {
                      final contact = recentTalks[index];
                      return Container(

                        margin: EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Container(
                              width: 60,
                              height: 60,
                              color: Colors.grey[300],
                              child: Image.network(
                                contact.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: Icon(Icons.person, color: Colors.grey[500]),
                                  );
                                },
                              ),
                            ),
                          ),
                          title: Text(
                            contact.name,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                          subtitle: Text(
                            contact.subtitle,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 14,
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 35,
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.local_phone_outlined,
                                  color:primColor,
                                  size: 18,
                                ),
                              ),
                              SizedBox(width: 12),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => VideoCallScreen(contactName: contact.name),
                                    ),
                                  );
                                },
                                child: Container(
                                  width: 35,
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: primColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.video_call_outlined,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Video Call Screen - Exact match to right side of image
class VideoCallScreen extends StatefulWidget {
  final String contactName;

  VideoCallScreen({required this.contactName});

  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  // Replace with your actual GetStream.io API key
  static const String apiKey = '6p5abjwse2jp';
  static const String apiSecret = 'r5mbg8fvhup5rfvph2gsxvu59jj8enfx2sre9p8gnxnh8dy66me37sg737c3sy6s';
  static const String roomName = 'Test Room'; // Predefined room as required

  StreamVideo? _client;
  Call? _call;
  bool _isInitialized = false;
  bool _isInCall = false;
  String? _userId;
  String _connectionStatus = 'Initializing...';
  bool _isMuted = false;
  bool _isVideoEnabled = true;

  @override
  void initState() {
    super.initState();
    _initializeAndAutoJoin();
  }

  Future<void> _initializeAndAutoJoin() async {
    await _requestPermissions();
    await _setupStreamClient();
    await _autoJoinRoom();
  }

  Future<void> _requestPermissions() async {
    setState(() {
      _connectionStatus = 'Requesting permissions...';
    });

    final statuses = await [
      Permission.camera,
      Permission.microphone,
    ].request();

    if (statuses.values.any((status) => status.isDenied)) {
      setState(() {
        _connectionStatus = 'Permissions denied';
      });
      _showError('Camera and microphone permissions are required');
      return;
    }
  }

  Future<void> _setupStreamClient() async {
    try {
      setState(() {
        _connectionStatus = 'Setting up client...';
      });

      // Check if StreamVideo is already initialized
      try {
        // Try to get existing instance first
        _client = StreamVideo.instance;
        print('Using existing StreamVideo instance');
      } catch (e) {
        // If no instance exists, create a new one
        print('Creating new StreamVideo instance');

        // Generate random user ID as required
        _userId = 'user${Random().nextInt(999999)}';

        String _generateJWTToken(String userId) {
          final jwt = JWT({
            'user_id': userId,
            'iss': apiKey,
            'sub': 'user/$userId',
            'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
            'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
          });

          return jwt.sign(SecretKey(apiSecret));
        }

        final token = _generateJWTToken(_userId!);

        _client = StreamVideo(
          apiKey,
          user: User.regular(
            userId: _userId!,
            name: 'User $_userId',
          ),
          userToken: token,
        );
      }

      // If we're using an existing client, get/generate user ID
      if (_userId == null) {
        _userId = _client?.currentUser?.id ?? 'user${Random().nextInt(999999)}';
      }

      _call = _client!.makeCall(
        callType: StreamCallType.defaultType(),
        id: roomName.toLowerCase().replaceAll(' ', '-'),
      );

      setState(() {
        _isInitialized = true;
        _connectionStatus = 'Ready to join room';
      });
    } catch (e) {
      print('Error setting up Stream client: $e');
      setState(() {
        _connectionStatus = 'Setup failed: $e';
      });
      _showError('Failed to initialize: $e');
    }
  }

  Future<void> _autoJoinRoom() async {
    if (!_isInitialized || _call == null) return;

    try {
      setState(() {
        _connectionStatus = 'Joining Test Room...';
      });

      // Automatically join the predefined room
      await _call!.join();

      setState(() {
        _isInCall = true;
        _connectionStatus = 'Connected to Test Room';
      });
    } catch (e) {
      print('Error joining room: $e');
      setState(() {
        _connectionStatus = 'Failed to join room: $e';
      });
      _showError('Failed to join Test Room: $e');
    }
  }

  Future<void> _endCall() async {
    if (!_isInCall || _call == null) return;

    try {
      await _call!.leave();
      setState(() {
        _isInCall = false;
        _connectionStatus = 'Call ended';
      });
      Navigator.pop(context);
    } catch (e) {
      print('Error ending call: $e');
      _showError('Failed to end call: $e');
    }
  }

  Future<void> _toggleMicrophone() async {
    if (_call == null) return;

    setState(() {
      _isMuted = !_isMuted;
    });

    try {
      await _call!.setMicrophoneEnabled(enabled: !_isMuted);
    } catch (e) {
      print('Error toggling microphone: $e');
    }
  }

  Future<void> _toggleVideo() async {
    if (_call == null) return;

    setState(() {
      _isVideoEnabled = !_isVideoEnabled;
    });

    try {
      await _call!.setCameraEnabled(enabled: _isVideoEnabled);
    } catch (e) {
      print('Error toggling video: $e');
    }
  }

  void _showError(String message) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 5),
        ),
      );
    }
  }

  @override
  void dispose() {
    if (_isInCall && _call != null) {
      _call!.leave();
    }
    // Don't dispose the client here as it might be used elsewhere
    // _client?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   //   appBar: AppBar(backgroundColor: Colors.blue,),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8E8E8),
              Color(0xFFD0D0D0),
            ],
          ),
        ),
        child: SafeArea(
          child: _buildCallInterface(),
        ),
      ),
    );
  }

  // In your _buildCallInterface() method, replace the existing overlay section with this:

  // In your _buildCallInterface() method, replace the existing overlay section with this:

  // In your _buildCallInterface() method, replace the existing overlay section with this:

  Widget _buildCallInterface() {
    return Stack(
      children: [
        // Main video background (simulated large person)
        Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            color: Colors.grey[300],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(25),
            child: Image.network(
              'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=400&q=80',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey[300],
                  child: Center(
                    child: Icon(Icons.person, size: 100, color: Colors.grey[500]),
                  ),
                );
              },
            ),
          ),
        ),

        // Stream Video Content (if connected) - Wrapped to control visibility
        if (_isInCall && _call != null)
          Container(
            child: StreamCallContainer(
              call: _call!,
              callContentWidgetBuilder: (context, call) {
                return StreamCallContent(
                  call: call,
                );
              },
            ),
          )
        else
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _connectionStatus,
                  style: TextStyle(fontSize: 18, color: Colors.black54),
                ),
              ],
            ),
          ),

        // AGGRESSIVE UI BLOCKING - Multiple layers to ensure coverage
        // Top area complete blocker
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 120,
          child: Container(
            color: Color(0xFFE8E8E8), // Solid color matching background
            child: Container(
              height: 120,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.0, 0.7, 1.0],
                  colors: [
                    Color(0xFFE8E8E8),
                    Color(0xFFE8E8E8).withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Bottom area complete blocker
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          height: 200,
          child: Container(
            color: Colors.transparent, // Solid color matching background
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  stops: [0.0, 0.5, 1.0],
                  colors: [
                    Color(0xFFE8E8E8),
                    Color(0xFFE8E8E8).withOpacity(0.8),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),

        // Extra safety overlay - covers any remaining UI elements
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: IgnorePointer(
            ignoring: true, // Allow touches to pass through to video
            child: Container(
              child: Column(
                children: [
                  Container(
                    height: 120,
                    color: secColor,
                  ),
                  Expanded(child: Container()), // Middle area stays transparent for video
                  Container(
                    height: 180,
                    color: secColor, // Bottom area with semi-transparent color
                  ),
                ],
              ),
            ),
          ),
        ),

        // Back button (top left) - Above all overlays
        Positioned(
          top: 50,
          left: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Camera flip button (top right) - Above all overlays
        Positioned(
          top: 50,
          right: 20,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.5),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(20),
                onTap: () async {
                  if (_call != null) {
                    try {
                      await _call!.flipCamera();
                    } catch (e) {
                      print('Error flipping camera: $e');
                    }
                  }
                },
                child: Container(
                  width: 40,
                  height: 40,
                  child: Icon(
                    Icons.flip_camera_ios_outlined,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
            ),
          ),
        ),

        // Small video preview (bottom right)
        Positioned(
          bottom: 120,
          right: 20,
          child: Container(
            width: 90,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.white, width: 2),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(13),
              child: Image.network(
                'https://images.unsplash.com/photo-1494790108755-2616b612b786?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=150&q=80',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey[400],
                    child: Icon(Icons.person, color: Colors.white, size: 30),
                  );
                },
              ),
            ),
          ),
        ),

        // Connection status indicator (for debugging)
        if (!_isInCall)
          Positioned(
            top: 100,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.7),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                _connectionStatus,
                style: TextStyle(color: Colors.white, fontSize: 12),
                textAlign: TextAlign.center,
              ),
            ),
          ),

        // Bottom control buttons - Your custom UI
        Positioned(
          bottom: 40,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // Video toggle button
              _buildBottomButton(
                icon: _isVideoEnabled ? Icons.videocam_outlined : Icons.videocam_off_outlined,
                onPressed: _toggleVideo,
                backgroundColor: Colors.white,
                iconColor: primColor,
              ),

              // End call button (red, larger)
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  border: Border.all(
                    color: Colors.redAccent.withOpacity(0.8),
                    width: 1,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: _buildBottomButton(
                    icon: Icons.call_end_outlined,
                    onPressed: _endCall,
                    backgroundColor: Colors.redAccent,
                    iconColor: Colors.white,
                    size: 65,
                  ),
                ),
              ),

              // Microphone button
              _buildBottomButton(
                icon: _isMuted ? Icons.mic_off_outlined : Icons.mic_none_rounded,
                onPressed: _toggleMicrophone,
                backgroundColor: _isMuted
                    ? Colors.white
                    : Colors.white.withOpacity(0.9),
                iconColor: primColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBottomButton({
    required IconData icon,
    required VoidCallback onPressed,
    required Color backgroundColor,
    required Color iconColor,
    double size = 50,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Icon(
          icon,
          color: iconColor,
          size: size * 0.4,
        ),
      ),
    );
  }
}