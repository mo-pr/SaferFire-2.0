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
export class ClientDto{
    client: Socket;
    firestation: string;
    ClientDto(cl:Socket,fs:string){
        this.client = cl;
        this.firestation = fs;
    }
}