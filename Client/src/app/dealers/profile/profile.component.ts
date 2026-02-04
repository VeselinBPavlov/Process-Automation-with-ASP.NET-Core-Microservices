import { Component, OnInit } from '@angular/core';
import { FormGroup, FormBuilder, Validators } from '@angular/forms';
import { Profile } from './profile.model';
import { ProfileService } from './profile.service';
import { PasswordChange } from './password.model';
import { Router } from '@angular/router';

@Component({
  selector: 'app-profile',
  templateUrl: './profile.component.html',
  styleUrls: ['./profile.component.css'],
  standalone: false
})
export class ProfileComponent implements OnInit {
  profileForm!: FormGroup;
  user!: Profile;
  changePasswordForm: FormGroup;
  id!: string;
  constructor(private fb: FormBuilder, private profileService: ProfileService, private router: Router) { 
    this.changePasswordForm = this.fb.group({
      currentPassword: ['', Validators.required],
      newPassword: ['', Validators.required],
    })
  }

  ngOnInit(): void {
    this.id = localStorage.getItem('dealerId') || '';
    this.profileService.getDealer(this.id).subscribe(u => {
      this.user = u
      console.log(this.user.name)
      this.profileForm = this.fb.group({
        name: [this.user.name, Validators.required],
        phoneNumber: [this.user.phoneNumber, Validators.required],
      })
      console.log(this.profileForm.value)
    })
  }

  fetchUser() {
    
  }

  editProfile() {
    this.profileService.editDealer(this.id, this.profileForm.value).subscribe(res => {
      this.router.navigate(['cars'])
    })
  }

  changePassword() {
    this.profileService.changePassword(this.changePasswordForm.value).subscribe(res => {
      localStorage.clear()
      window.location.reload()
      this.router.navigate(['auth']);
    })
  }

}
