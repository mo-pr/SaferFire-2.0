import { Socket } from 'socket.io';

export class UserLoginDto{
    email: string;
    passwordhash: string;
}
export class UserRegistrationDto{
    email: string;
    passwordhash: string;
    firestation: string;
}
export class GuestRegistrationDto{
    firestation: string;
}