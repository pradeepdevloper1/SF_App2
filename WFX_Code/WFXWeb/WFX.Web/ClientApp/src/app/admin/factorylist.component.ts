import { Component, Inject, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { FactoryService } from '../services/factory.service';
import { FactoryModel } from '../../models/FactoryModel';
import { environment } from 'src/environments/environment';
import { CulsterModel } from 'src/models/CulsterModel';

@Component({
  selector: 'app-admin',
  templateUrl: './factorylist.component.html'
})

export class FactoryListComponent implements OnInit {

  UserName: string;
  Url: string;
  header: any;
  auth: string;
  data: any;
  /*  public factorymodel: FactoryModel;*/

  public gridApi;
  public gridColumnApi;
  public columnDefs;
  public defaultColDef;
  public rowData: any;
  clusterlist: any;
  OrganisationList: any;
  Clustervaluechanged: boolean = false;
  organisationvaluechanged: boolean = false;
  organisationid: number=0;
  clusterid: number=0;
  organisationPlaceholder: string = 'SELECT'
  clusterPlaceholder: string = 'SELECT'
  public CulsterModel: CulsterModel;

  constructor(
    private http: HttpClient,
    private router: Router,
    @Inject('BASE_URL') baseUrl: string,
    private FactoryService: FactoryService
  ) {
    this.columnDefs = [
      { headerName: 'FactoryID', field: "factoryID", hide: true, },
      { headerName: 'Name', field: "factoryName", minWidth: 100 },
      { headerName: 'Cluster', field: "clusterName", minWidth: 100 },
      { headerName: 'Organisation', field: "organisationName", minWidth: 100 },
      //{ headerName: 'NoOfShifts', field: "noOfShifts" },
      { headerName: 'Status', field: "factoryStatus" },
      { headerName: 'Type', field: "factoryType" },
      { headerName: 'No Of Lines', field: "noOfLine" },
      { headerName: 'Smart Lines', field: "smartLines" },
      { headerName: '', field: "factoryID", minWidth: 100, cellRenderer: params => "<a href ='/Admin/FactoryWizard/" + params.value + "' ><img src='../../assets/images/icon-edit-master.svg'></a>" },
    ];
    this.defaultColDef = { resizable: true, filter: 'agTextColumnFilter' };

    this.loadScripts();
    this.UserName = sessionStorage.getItem('userFirstName') + " " + sessionStorage.getItem('userLastName').replace("-", "");
    this.Url = environment.apiUrl;
    this.auth = sessionStorage.getItem('auth');
  }

  ngOnInit() {

  }

  onGridReady(params) {
    this.gridApi = params.api;
    this.gridColumnApi = params.columnApi;
    params.api.sizeColumnsToFit();
    this.getData();


  }


  // Method to dynamically load JavaScript
  loadScripts() {
    const dynamicScriptsbody = [
      'assets/js/custom.js',
    ];

    for (let i = 0; i < dynamicScriptsbody.length; i++) {
      const node = document.createElement('script');
      node.src = dynamicScriptsbody[i];
      node.type = 'text/javascript';
      node.async = false;
      document.getElementsByTagName('body')[0].appendChild(node);
    }
  }
  ClusterList() {
    console.log(this.organisationid)
    this.FactoryService.FillCulster(this.organisationid).subscribe(
      res => {
        if(res.data && res.data.length>0){
          res.data.unshift({ id: 0, text: 'All' });

        this.clusterlist = res.data;
        }else{
          this.clusterlist=[];
        }
      })
  }
  organisationmodelChangeHandler(event: any) {
    if (this.organisationvaluechanged) {
      if (event != "") {
        this.organisationid = event;
        this.CulsterModel.organisationID = parseInt(event);
        this.ClusterList();
      }
      else {
        this.CulsterModel.organisationID = 0;
      }
    }
  }

  clustermodelChangeHandler(event: any) {
    if (this.Clustervaluechanged) {
      if (event != 0 && event) {
        this.clusterid = event;
        this.CulsterModel.clusterID = parseInt(event);

      }
      else if (this.clusterPlaceholder === 'SELECT') {
        this.CulsterModel.clusterID = 0;
        this.clusterid = 0;
      }
      else {
        this.CulsterModel.clusterID = this.clusterlist[0].id;
        this.clusterid = this.clusterlist[0].id;
      }


      this.getgridData();
    }
  }

  async getData() {
    this.CulsterModel = new CulsterModel();
    const t = await this.FactoryService.FillOrganisation().toPromise();
if(t.data && t.data.length>0){
  t.data.unshift({ id: 0, text: 'All' });

    this.OrganisationList = t.data
}
   
    const res = await this.FactoryService.FillCulster(this.organisationid).toPromise();
    if(res.data && res.data.length>0){
      res.data.unshift({ id: 0, text: 'All' });

    this.clusterlist = res.data;
    }
   
      this.CulsterModel.organisationID = this.organisationid;
   
      this.CulsterModel.clusterID = this.clusterid;
    
    this.Clustervaluechanged = true;
    this.organisationvaluechanged = true;
    this.getgridData();
  }
  getgridData() {
    
    this.http
      .post(this.Url + "Factory/GetFactory", this.CulsterModel, {
        headers: new HttpHeaders().set('Authorization', "Bearer " + this.auth)
      })
      .subscribe((data: any) => {
        if (data.status == 400) {
          this.rowData = [];
        }
        else {
          this.rowData = data;
        }
      });
  }
}

