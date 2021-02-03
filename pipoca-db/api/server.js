import 'dotenv/config'; 
import express from 'express';
const morgan = require('morgan');
import helmet from 'helmet';
import subdomain from 'express-subdomain';
import fs from 'fs';
import path from 'path';
import routes from './routes';
require('./models');

const app = express();
const port = process.env.PORT || 3000;




app.use(helmet());
app.use(morgan('combined'));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));

app.use(subdomain('api', routes.user));


app.use((req, res) => {
     res.status(404).send('404: Page not Found 💩!');
}); 




app.listen(port , () => {
    console.log(`🎊welcome to Pipoca🍿 http://localhost:${port}`);
})