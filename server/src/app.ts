import express from 'express';
import cors from 'cors';
import helmet from 'helmet';
import morgan from 'morgan';
import { router } from './routes/index.js';
import { errorHandler } from './middleware/error.middleware.js';

export const app = express();

app.use(helmet());
app.use(cors({ origin: true, credentials: true }));
app.use(morgan('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.use('/api', router);

app.use(errorHandler);
