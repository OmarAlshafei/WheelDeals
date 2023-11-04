const request = require('supertest');
const app = require('./server');

describe('POST /api/register', () => {
    it('should respond with a message', async () => {
      const response = await request(app)
        .post('/api/register')
        .send({
            firstName: "firstName",
            lastName: "lastName",
            email: "email",
            userName: "userName",
            password: "password",
        });
      expect(response.statusCode).toBe(200);
      expect(response.headers['content-type']).toEqual(expect.stringContaining('json'));
      expect(response.body['message']).toEqual(expect.stringContaining('User Added Successfully'));
      expect(response.body['error']).toEqual(expect.stringContaining(''));
    });
  });
  