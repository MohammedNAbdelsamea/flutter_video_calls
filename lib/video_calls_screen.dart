import 'dart:math';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stream_video_flutter/stream_video_flutter.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';



class VideoCallScreen extends StatefulWidget {
  @override
  _VideoCallScreenState createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  
  static const String apiKey = '6p5abjwse2jp';
  static const String roomName = 'Test Room'; // Predefined room as required

  StreamVideo? _client;
  Call? _call;
  bool _isInitialized = false;
  bool _isInCall = false;
  String? _userId;
  String _connectionStatus = 'Initializing...';

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

      // Generate random user ID as required
      _userId = 'user${Random().nextInt(999999)}';

      // First declare all helper functions at the top
      String _createBasicToken(String userId) {
        final timestamp = DateTime.now().millisecondsSinceEpoch;
        return 'dev_${userId}_$timestamp';
      }

      Future<String> _generateUserToken(String userId) async {
        return _createBasicToken(userId);
      }

      String _generateJWTToken(String userId) {
        const String apiSecret = 'r5mbg8fvhup5rfvph2gsxvu59jj8enfx2sre9p8gnxnh8dy66me37sg737c3sy6s';

        final jwt = JWT({
          'user_id': userId,
          'iss': apiKey,
          'sub': 'user/$userId',
          'iat': DateTime.now().millisecondsSinceEpoch ~/ 1000,
          'exp': DateTime.now().add(Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000,
        });

        return jwt.sign(SecretKey(apiSecret));
      }

      // Now use the functions after they've been declared
      final token = _generateJWTToken(_userId!);

      _client = StreamVideo(
        apiKey,
        user: User.regular(
          userId: _userId!,
          name: 'User $_userId',
        ),
        userToken: token,
      );

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
    } catch (e) {
      print('Error ending call: $e');
      _showError('Failed to end call: $e');
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
    _client?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Video Call'),
        backgroundColor: Colors.blue,
        elevation: 2,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (!_isInitialized) {
      return _buildLoadingScreen();
    }

    if (!_isInCall) {
      return _buildWaitingScreen();
    }

    return _buildCallInterface();
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          SizedBox(height: 24),
          Text(
            _connectionStatus,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'User ID: $_userId',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWaitingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_call_outlined,
            size: 80,
            color: Colors.grey,
          ),
          SizedBox(height: 16),
          Text(
            'Connection Issue',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            _connectionStatus,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _autoJoinRoom,
            child: Text('Retry Join Room'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCallInterface() {
    return StreamCallContainer(
      call: _call!,
      callContentBuilder: (context, call, callState) {
        return Stack(
          children: [
            // Main video content
            StreamCallContent(
              call: call,
              callState: callState,
              callControlsBuilder: (context, call, callState) {
                return _buildCustomControls(call, callState);
              },
            ),
            // Top status bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.black.withOpacity(0.7),
                      Colors.transparent,
                    ],
                  ),
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      Icon(Icons.videocam, color: Colors.white, size: 20),
                      SizedBox(width: 8),
                      Text(
                        roomName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Spacer(),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'LIVE',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCustomControls(Call call, CallState callState) {
    final localParticipant = callState.localParticipant;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Microphone toggle
            _buildControlButton(
              icon: localParticipant?.isAudioEnabled == true
                  ? Icons.mic
                  : Icons.mic_off,
              onPressed: () async {
                final isEnabled = localParticipant?.isAudioEnabled ?? false;
                await call.setMicrophoneEnabled(enabled: !isEnabled);
              },
              isActive: localParticipant?.isAudioEnabled ?? false,
            ),

            // Camera toggle
            _buildControlButton(
              icon: localParticipant?.isVideoEnabled == true
                  ? Icons.videocam
                  : Icons.videocam_off,
              onPressed: () async {
                final isEnabled = localParticipant?.isVideoEnabled ?? false;
                await call.setCameraEnabled(enabled: !isEnabled);
              },
              isActive: localParticipant?.isVideoEnabled ?? false,
            ),

            // Flip camera
            _buildControlButton(
              icon: Icons.flip_camera_ios,
              onPressed: () async {
                await call.flipCamera();
              },
              isActive: true,
            ),

            // End call button
            _buildControlButton(
              icon: Icons.call_end,
              onPressed: _endCall,
              isActive: false,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    required bool isActive,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor ?? (isActive ? Colors.white : Colors.grey[800]),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: backgroundColor == Colors.red
              ? Colors.white
              : (isActive ? Colors.black : Colors.white),
        ),
        onPressed: onPressed,
        iconSize: 24,
      ),
    );
  }
}
