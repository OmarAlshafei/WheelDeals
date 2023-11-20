const app = require('./server'); 
const request = require('supertest');
const {MongoClient} = require('mongodb');
const { MongoMemoryServer } = require('mongodb-memory-server');
let mongoServer;
let client;
    
    
    beforeAll(async () => {
      mongoServer = new MongoMemoryServer();
      const url = process.env.MONGODB_URL;
      client = new MongoClient(url, { useNewUrlParser: true, useUnifiedTopology: true });
      await client.connect();
    });
    
    afterAll(async () => {
      await client.close();
      await mongoServer.stop();
  });
  
  describe('Server API tests', () => {

  // test('POST /api/register - it should register a new user', async () => {
  //   const response = await request(server)
  //     .post('/api/register')
  //     .send({
  //         firstName: 'Test',
  //         lastName: 'User',
  //         userName: 'testuser',
  //         email: 'test@example.com',
  //         password: 'TestPassword@123',
  //       });
    
  //     expect(response.status).toBe(200);
  //   });
    
  test('POST /api/login - it should log in an existing user', async () => {
    const usersCollection = client.db('cop4331').collection('Users');
    const mockUser = {
      userName: 'a4',
      password: 'Abc@12345',
      isVerified: true,
    };
    await usersCollection.insertOne(mockUser);
    
    const res = await request(app)
      .post('/api/login')
      .send({ 
        userName: 'a4', 
        password: 'Abc@12345' 
      });
      
    expect(res.status).toBe(200);
    // expect(res.body).toHaveProperty('accessToken');

  });


});