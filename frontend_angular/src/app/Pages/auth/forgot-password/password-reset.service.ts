import { Injectable } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Observable } from 'rxjs';


export interface RequestPasswordResetRequest {
  email: string;
}

export interface VerifyResetCodeRequest {
  email: string;
  code: string;
}

export interface ResetPasswordRequest {
  email: string;
  code: string;
  password: string;
}

@Injectable({
  providedIn: 'root'
})
export class PasswordResetService {
  private apiUrl = 'http://localhost:3000/api/v1';

  constructor(private http: HttpClient) { }

  requestPasswordReset(request: RequestPasswordResetRequest): Observable<any> {
    return this.http.post(`${this.apiUrl}/auth/request_password_reset`, request);
  }

  verifyResetCode(request: VerifyResetCodeRequest): Observable<any> {
    return this.http.post(`${this.apiUrl}/auth/verify_reset_code`, request);
  }

  resetPassword(request: ResetPasswordRequest): Observable<any> {
    return this.http.post(`${this.apiUrl}/auth/reset_password`, request);
  }
}
