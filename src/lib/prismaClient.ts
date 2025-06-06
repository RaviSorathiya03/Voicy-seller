import {PrismaClient} from '@prisma/client';

declare global{
    var prisma: PrismaClient | null;
}

export const prismaClient = globalThis.prisma || new PrismaClient();
if(process.env.NODE_ENV !== 'production'){
    globalThis.prisma = prismaClient;
}