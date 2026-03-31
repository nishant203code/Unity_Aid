import 'package:flutter/material.dart';
import '../../widgets/theme/app_colors.dart';
import '../../models/chat_message_model.dart';
import 'dart:async';

class AIChatPage extends StatefulWidget {
  const AIChatPage({super.key});

  @override
  State<AIChatPage> createState() => _AIChatPageState();
}

class _AIChatPageState extends State<AIChatPage> with TickerProviderStateMixin {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  final Map<String, String> _aiResponses = {
    'hello': 'Hello! I\'m UnityAid AI Assistant. How can I help you today?',
    'hi':
        'Hi there! I\'m here to help you with donations, NGOs, and any questions about UnityAid.',
    'help':
        'I can assist you with:\n• Finding NGOs\n• Making donations\n• Understanding donation cases\n• Navigating the app\n• General queries about UnityAid\n\nWhat would you like to know?',
    'donate':
        'To make a donation:\n1. Go to the Donate tab\n2. Browse available cases\n3. Select a case you want to support\n4. Choose your donation amount\n5. Complete the payment\n\nWould you like me to guide you through the process?',
    'ngo':
        'You can find NGOs by:\n• Using the NGO Search tab\n• Filtering by category or location\n• Viewing verified NGOs\n• Checking NGO profiles and their work\n\nWould you like to search for a specific type of NGO?',
    'payment':
        'UnityAid supports multiple payment methods:\n• Credit/Debit Cards\n• UPI\n• Net Banking\n• Digital Wallets\n\nAll transactions are secure and encrypted.',
    'profile':
        'To manage your profile:\n1. Tap the menu icon (hamburger)\n2. Go to Profile\n3. Edit your details\n\nYou can update your name, photo, contact info, and preferences.',
    'cases':
        'Donation cases are verified needs posted by NGOs. Each case includes:\n• Description of the need\n• Required amount\n• Beneficiary details\n• NGO verification\n• Progress tracking\n\nYou can browse cases in the News Feed or Donate section.',
    'verify':
        'Verified accounts have a green checkmark. This means:\n• The account has been authenticated\n• Documents have been verified\n• The entity is legitimate\n\nAll verified NGOs undergo a thorough verification process.',
    'security':
        'Your security is our priority:\n✓ End-to-end encryption\n✓ Secure payment gateway\n✓ Two-factor authentication\n✓ Regular security audits\n✓ Data privacy compliance\n\nYou can manage security settings in Settings > Security.',
  };

  final List<String> _quickReplies = [
    'How to donate?',
    'Find NGOs',
    'Payment methods',
    'Help',
  ];

  @override
  void initState() {
    super.initState();
    _addWelcomeMessage();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addWelcomeMessage() {
    setState(() {
      _messages.add(ChatMessage(
        id: '0',
        message:
            'Hello! 👋 I\'m your UnityAid AI Assistant. I\'m here to help you with donations, finding NGOs, and answering any questions about the app. How can I assist you today?',
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
  }

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;
    final userMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: message,
      isUser: true,
      timestamp: DateTime.now(),
    );
    setState(() {
      _messages.add(userMessage);
      _isTyping = true;
    });
    _messageController.clear();
    _scrollToBottom();
    Timer(
        const Duration(milliseconds: 1500), () => _generateAIResponse(message));
  }

  void _generateAIResponse(String userMessage) {
    final aiMessage = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      message: _getAIResponse(userMessage.toLowerCase()),
      isUser: false,
      timestamp: DateTime.now(),
    );
    setState(() {
      _isTyping = false;
      _messages.add(aiMessage);
    });
    _scrollToBottom();
  }

  String _getAIResponse(String message) {
    for (var entry in _aiResponses.entries) {
      if (message.contains(entry.key)) return entry.value;
    }
    return 'I\'m here to help! Could you please provide more details or choose from these topics:\n\n• Donations\n• NGO search\n• Payment methods\n• Profile settings\n• Security\n\nOr type "help" to see all available options.';
  }

  void _scrollToBottom() {
    Timer(const Duration(milliseconds: 300), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.psychology_alt,
                  color: AppColors.primary, size: 20),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('AI Assistant',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Text('Always here to help',
                    style: TextStyle(
                        fontSize: 11,
                        color: theme.textTheme.bodySmall?.color,
                        fontWeight: FontWeight.normal)),
              ],
            ),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) {
              if (value == 'clear') {
                setState(() {
                  _messages.clear();
                  _addWelcomeMessage();
                });
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Chat cleared')));
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'clear',
                child: Row(children: [
                  Icon(Icons.delete_outline, size: 20),
                  SizedBox(width: 8),
                  Text('Clear Chat')
                ]),
              ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length + (_isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length && _isTyping)
                  return _buildTypingIndicator(isDark);
                return _buildMessageBubble(_messages[index], isDark, theme);
              },
            ),
          ),
          if (_messages.length == 1) _buildQuickReplies(theme),
          _buildInputArea(theme, isDark),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(
      ChatMessage message, bool isDark, ThemeData theme) {
    final bubbleBg = message.isUser
        ? AppColors.primary
        : (isDark ? const Color(0xFF2A2A2A) : Colors.white);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment:
            message.isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!message.isUser) ...[
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child: const Icon(Icons.psychology_alt,
                  size: 16, color: AppColors.primary),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Column(
              crossAxisAlignment: message.isUser
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: bubbleBg,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(message.isUser ? 16 : 4),
                      bottomRight: Radius.circular(message.isUser ? 4 : 16),
                    ),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 5,
                          offset: const Offset(0, 2))
                    ],
                  ),
                  child: Text(
                    message.message,
                    style: TextStyle(
                      color: message.isUser
                          ? Colors.white
                          : theme.textTheme.bodyMedium?.color,
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Text(_formatTime(message.timestamp),
                    style: TextStyle(
                        fontSize: 10, color: theme.textTheme.bodySmall?.color)),
              ],
            ),
          ),
          if (message.isUser) ...[
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.primary.withOpacity(0.15),
              child:
                  const Icon(Icons.person, size: 16, color: AppColors.primary),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator(bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: AppColors.primary.withOpacity(0.15),
            child: const Icon(Icons.psychology_alt,
                size: 16, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF2A2A2A) : Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [0, 1, 2].map((i) => _buildTypingDot(i)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypingDot(int index) {
    return Padding(
      padding: EdgeInsets.only(left: index == 0 ? 0 : 4),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: const Duration(milliseconds: 600),
        builder: (context, value, child) {
          return Opacity(
            opacity: (value + index * 0.3) % 1.0,
            child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                    color: Colors.grey, shape: BoxShape.circle)),
          );
        },
      ),
    );
  }

  Widget _buildQuickReplies(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Replies:',
              style: TextStyle(
                  fontSize: 12,
                  color: theme.textTheme.bodySmall?.color,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickReplies
                .map((reply) => ActionChip(
                      label: Text(reply),
                      onPressed: () => _sendMessage(reply),
                      side:
                          BorderSide(color: AppColors.primary.withOpacity(0.4)),
                      labelStyle: const TextStyle(
                          color: AppColors.primary, fontSize: 12),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea(ThemeData theme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, -2))
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: isDark
                      ? const Color(0xFF2A2A2A)
                      : const Color(0xFFF0F0F0),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: 'Ask me anything...',
                    hintStyle:
                        TextStyle(color: theme.textTheme.bodySmall?.color),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 12),
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: _sendMessage,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: const BoxDecoration(
                  color: AppColors.primary, shape: BoxShape.circle),
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white, size: 20),
                onPressed: () => _sendMessage(_messageController.text),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
