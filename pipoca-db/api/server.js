import 'dotenv/config';
import express from 'express';
const morgan = require('morgan');
import helmet from 'helmet';
import subdomain from 'express-subdomain';
import fs from 'fs';
import path from 'path';
import routes from './routes';
import cors from 'cors';

require('./models');

const app = express();
app.set('trust proxy', 1);
const port = process.env.PORT || 3000;

const accessLogStream = fs.createWriteStream(
    path.join(__dirname, '../access.log'), { flags: 'a' }
);


app.set('view engine', 'ejs');
app.use(express.static(path.join(__dirname, 'public')));
app.use(helmet());
app.use(cors());
app.use(morgan('combined', { stream: accessLogStream }));
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ extended: true, limit: '50mb' }));
app.use(routes.user);
//app.use(subdomain('api', routes.user));


app.use((req, res) => {
    res.status(404).render('404');

});




app.listen(port, () => {
    console.log(`
‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗
      __________  ____  __________  __________  __________  __________
     |          ||    ||          ||          ||          ||    __    |
     |     __   ||    ||     __   ||    __    ||          ||   |__|   | 
     |    |__|  ||    ||    |__|  ||   |  |   ||          ||          |
     |     _____||    ||     _____||   |__|   ||        __||          |
     |    |      |    ||    |      |          ||       |__ |    __    |
     |____|      |____||____|      |__________||__________||___|  |___|
                            _______________
                           | Version 1.0.0 |
                       http://api.pipoca.ao:${port}
                           |_______________|
‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗‗
`);
})