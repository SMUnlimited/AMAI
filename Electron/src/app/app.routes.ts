import { Routes } from '@angular/router';

export const routes: Routes = [
  {
    path: '',
    redirectTo: 'home',
    pathMatch: 'full'
  },
  {
    path: 'home',
    loadComponent: () => import('./home/home.component').then(component => component.HomeComponent)
  },
  {
    path: 'detail',
    loadComponent: () => import('./detail/detail.component').then(component => component.DetailComponent)
  },
  {
    path: '**',
    loadComponent: () => import('./shared/components/page-not-found/page-not-found.component')
      .then(component => component.PageNotFoundComponent)
  }
];
