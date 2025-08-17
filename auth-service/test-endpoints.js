// Simple test to verify auth service endpoints
const axios = require('axios');

const BASE_URL = 'http://localhost:3002';

async function testHealthEndpoint() {
  try {
    console.log('🔍 Testing health endpoint...');
    const response = await axios.get(`${BASE_URL}/health`);
    console.log('✅ Health check passed:', response.data);
    return true;
  } catch (error) {
    console.log('❌ Health check failed:', error.message);
    return false;
  }
}

async function testWalletInitiate() {
  try {
    console.log('🔍 Testing wallet initiate endpoint...');
    const response = await axios.post(`${BASE_URL}/auth/wallet/initiate`, {
      walletAddress: '0x742d35CC6634C0532925a3b8D402B405F4032888'
    });
    console.log('✅ Wallet initiate passed:', response.data);
    return response.data;
  } catch (error) {
    console.log('❌ Wallet initiate failed:', error.response?.data || error.message);
    return null;
  }
}

async function testInvalidWalletAddress() {
  try {
    console.log('🔍 Testing invalid wallet address...');
    const response = await axios.post(`${BASE_URL}/auth/wallet/initiate`, {
      walletAddress: 'invalid-address'
    });
    console.log('❌ Should have failed but passed:', response.data);
    return false;
  } catch (error) {
    if (error.response?.status === 400) {
      console.log('✅ Invalid address properly rejected:', error.response.data);
      return true;
    } else {
      console.log('❌ Unexpected error:', error.message);
      return false;
    }
  }
}

async function runTests() {
  console.log('🚀 Starting Auth Service Tests\n');
  
  const healthPassed = await testHealthEndpoint();
  console.log('');
  
  if (!healthPassed) {
    console.log('❌ Health check failed - auth service may not be running');
    console.log('💡 Make sure to start the auth service first:');
    console.log('   cd auth-service && npm run dev');
    return;
  }
  
  await testWalletInitiate();
  console.log('');
  
  await testInvalidWalletAddress();
  console.log('');
  
  console.log('🎉 Tests completed!');
  console.log('💡 Visit http://localhost:3000/auth-demo for full testing');
}

runTests().catch(console.error);
