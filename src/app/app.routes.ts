import type { Routes } from "@angular/router";

export const routes: Routes = [
	{
		path: "",
		loadComponent: () => import("./features/home/home"),
	},
];
