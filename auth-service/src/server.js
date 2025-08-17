const Web3AuthService = require('./Web3AuthService');

// Start server
const authService = new Web3AuthService();
const PORT = process.env.PORT || 3002;

authService.app.listen(PORT, () => {
  console.log(`🚀 Web3 Auth Server running on port ${PORT}`);
  console.log(`📊 Health check: http://localhost:${PORT}/health`);
  console.log(`🔐 Auth endpoints: http://localhost:${PORT}/auth/*`);
  console.log(`🌍 Environment: ${process.env.NODE_ENV || 'development'}`);
  
  if (process.env.NODE_ENV === 'development') {
    console.log('\n🛠️  Development Mode - Smart contract checks may be bypassed');
    console.log('📝 Make sure to configure your .env file with proper values');
  }
});

// Graceful shutdown
process.on('SIGTERM', () => {
  console.log('🛑 SIGTERM received, shutting down gracefully');
  process.exit(0);
});

process.on('SIGINT', () => {
  console.log('🛑 SIGINT received, shutting down gracefully');
  process.exit(0);
});

module.exports = authService;
