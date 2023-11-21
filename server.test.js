const app = require('./server'); 
const request = require('supertest');
  
  describe('Server API tests', () => {

  test('POST /api/register - it should register a new user', async () => {
    const response = await request(app)
      .post('/api/register')
      .send({
          firstName: 'Test',
          lastName: 'User',
          userName: 'test_2user',
          email: 'testing_2@example.com',
          password: 'TestPassword@123',
          isVerified: 'true'
        });
    
      expect(response.status).toBe(200);
    });
    
  test('POST /api/login - it should log in an existing user', async () => {
    
    const res = await request(app)
      .post('/api/login')
      .send({ 
        userName: 'a', 
        password: 'Abcd@1234' 
      });
      
    expect(res.status).toBe(200);
    expect(res.body).toHaveProperty('accessToken');

  });
  
  test('POST /api/homepage - returns array of popular cars, prices and types', async () => {
    
    const res = await request(app)
      .post('/api/homepage')
      .send({ 
        jwtToken: '90554146df2f1df84db1e23697401f1a', 
      });
      
    expect(res.status).toBe(200);
  });
  
  test('POST /api/makes - returns array of makes', async () => {
    
    const res = await request(app)
      .post('/api/makes')
      .send({ 
        jwtToken: '90554146df2f1df84db1e23697401f1a', 
      });
      
    expect(res.status).toBe(200);
  });
  
  test('POST /api/models - returns array of array of models for a specific make', async () => {
    
    const res = await request(app)
      .post('/api/models')
      .send({ 
        make: 'Ford',
        jwtToken: '90554146df2f1df84db1e23697401f1a', 
      });
      
    expect(res.status).toBe(200);
  });
  
  test('POST /api/search - returns car details', async () => {
    
    const res = await request(app)
      .post('/api/search')
      .send({ 
        make: 'Ford',
        model: 'F-150',
        jwtToken: '90554146df2f1df84db1e23697401f1a', 
      });
      
    expect(res.status).toBe(200);
  });

});