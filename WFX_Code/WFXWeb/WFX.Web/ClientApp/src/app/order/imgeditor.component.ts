import { Component, Inject, OnInit } from '@angular/core';
import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Router } from '@angular/router';
import { Observable } from 'rxjs';
import { AgGridAngular } from 'ag-grid-angular';
import { FormBuilder, FormGroup, FormsModule, Validators } from '@angular/forms';
import { environment } from '../../environments/environment';
import { OrderService } from '../services/order.service';
import { POViewModel } from '../../models/POViewModel';
import { ActivatedRoute } from '@angular/router';
import { TranslateService } from '@ngx-translate/core';
import { MatSnackBar } from '@angular/material/snack-bar';
import { OBModel } from 'src/models/OBModel';
import { TranslationService } from '../services/translation.service';
import { UploadOBService } from '../services/uploadob.service';

declare function importExcel(): any;
declare function saveob(pono: string): any;

@Component({
  selector: 'app-order',
  templateUrl: './imgeditor.component.html'
})

export class IMGEditorComponent implements OnInit {
  selecttedFile = null;
  Url: string;
  UserName: string;
  auth: string;
  public poviewmodel: POViewModel;
  sono: string;
  pono: string;
  userID: number;
  posearchtext: string;
  poimageid: number;
  poimageName: string;
  imagecount: number;
  imgno: number;
  title: any = 'obeditorpo';
  showSaveButton: boolean = false;
  OBModel: OBModel;
  updatedRows = [];

  public gridApi;
  public gridColumnApi;
  public columnDefs;
  public defaultColDef;
  public rowData: any;
  public img_ob;
  constructor(
    private translate: TranslateService,
    private router: Router,
    private http: HttpClient,
    private os: OrderService,
    private _Activatedroute: ActivatedRoute,
    private msg: MatSnackBar,
    private readonly ts: TranslationService,
    private readonly uob: UploadOBService
  ) {
    let lang = sessionStorage.getItem('lang');
    let gridData = translate.store.translations[lang].lang
    this.columnDefs = [
      { headerName: gridData['sNo'], field: "sNo" },
      { headerName: gridData['operationCode'], field: "operationCode", editable: true },
      { headerName: gridData['operationName'], field: "operationName", editable: true },
      { headerName: gridData['smv'], field: "smv", editable: true },
      { headerName: gridData['obLocation'], field: "obLocation", editable: true },
    ];
    this.defaultColDef = {
      resizable: true,
      minWidth: 80,
      flex: 1,
      filter: true,
    };

    this.loadScripts();
    this.Url = environment.apiUrl;
    this.auth = sessionStorage.getItem('auth');
    this.UserName = sessionStorage.getItem('userFirstName') + " " + sessionStorage.getItem('userLastName').replace("-", "");
    this.userID = parseInt(sessionStorage.getItem('userID'));
  }

  factoryProcessList: any[] = [];
  processTypeCode = '';
  existingObs: any[] = [];
  selectedExistingOBFileUploadId = 0;
  selectedProcessTypeCode = '';
  fppos: any[] = [];
  selectedFppo = '';
  productList: any[] = [];
  selectedProductId: any;
  productId = 0;

  ngOnInit() {
    this.imagecount = 0;
    this._Activatedroute.paramMap.subscribe(params => {
      this.sono = params.get('sono');
      this.poviewmodel = new POViewModel();
      this.poviewmodel.soNo = this.sono;
      this.img_ob = parseInt(params.get('img_ob'));
      this.poviewmodel.picesChecked = this.img_ob;
      if (this.img_ob == 0) {
        this.title = 'imageeditorpo';
      }
      this.getData();
      this.fillProcessTypes();

      this.loadSearch();
    });
  }

  private fillProcessTypes() {
    this.os.FactoryProcessList({ SONo: this.sono }).subscribe(
      res => {
        this.factoryProcessList = res.data;
        this.selectedProcessTypeCode = this.factoryProcessList[0].processType;
        this.fillFPPOs();
        this.fillProducts();
      });
  }

  private fillFPPOs() {
    this.os.POListOfSO({ SONo: this.sono, ProcessTypeCode: this.selectedProcessTypeCode }).subscribe(
      res => {
        this.fppos = res.data;
      });
  }

  fillProducts() {
    this.uob.GetOBProducts(this.selectedProcessTypeCode).subscribe(res => {
      this.productList = res;
    });
  }

  fillExistingOBs() {
    this.uob.GetOBFileUploadList({ ProcessTypeCode: this.selectedProcessTypeCode, ProductID: Number(this.selectedProductId) }).subscribe(res => {
      if (res && res.length) {
        let optList = [];
        res.forEach(e => {
          optList.push({ id: e.obFileUploadID, text: e.fileName });
        });
        this.existingObs = optList;
      }
    });
  }

  getData() {
    this.os.GetPOImages(this.sono).subscribe(
      res => {
        this.poviewmodel.imagelist = res.data;
        this.imagecount = (res.data && res.data.length) || 0;
        if (this.imagecount == 0 || this.imagecount == undefined) {
          this.imgno = 0;
        }
        else {
          this.imgno = (res.data[this.imagecount - 1].poImageID + 1);
        }

      })
    this.os.POOB(this.poviewmodel).subscribe(
      res => {
        this.rowData = res.data;
      })
  }

  loadSearch() {
    this.poviewmodel.posearchtext = this.posearchtext;
    this.poviewmodel.soNo = this.sono;
    this.os.POListOfSO(this.poviewmodel).subscribe(
      res => {
        this.poviewmodel.polist = res.data;
        this.poviewmodel.soNo = res.sono;
      })
  }

  onChangeEvent(event: any) {
    this.posearchtext = event.target.value;
    this.loadSearch();
  }

  SampleFile() {
    window.location.href = 'sample/obsample.xlsx';
  }

  UploadImage(event) {
    if (this.imagecount == 0 || this.imagecount == undefined) {
      this.imgno = 1;
    }
    else {
      this.imgno = this.imgno + 1;
    }
    if (event.target.files[0].type.includes('image')) {
      this.selecttedFile = <File>event.target.files[0];
      const endpoint = "Upload/Image/UploadImage/" + this.imgno + "?SONo=" + this.sono;
      const formData: FormData = new FormData();
      formData.append('file', this.selecttedFile, this.selecttedFile.name);


      this.http.post<any>(endpoint, formData)
        .subscribe(res => {
          if (res.status = 200) {
            sessionStorage.setItem("imgname", res.message);
            sessionStorage.setItem("imgpath", res.path);

            this.poviewmodel.soNo = this.sono;
            this.poviewmodel.imagePath = res.path;
            this.poviewmodel.imageName = res.filename;
            this.poviewmodel.imgno = this.imgno;
            this.os.PostPOImages(this.poviewmodel).subscribe(
              res => {
                this.poviewmodel.imagelist = res.data;
                this.imagecount = res.data.length;
                this.imgno = res.data[this.imagecount - 1].poImageID;
              });
          }
        });
    }
    else {
      alert("Invalid Format ! Please choose Image")
    }
  }

  ChangeImage(event, poimageid, previousimageName: string) {
    this.selecttedFile = <File>event.target.files[0];
    if (this.poimageid == undefined) {
      window.location.reload();
    }
    const endpoint = "Upload/Image/ChangeImage/" + this.poimageid + "/?SONo=" + this.sono + "&PreviousImageName=" + this.poimageName;
    const formData: FormData = new FormData();
    formData.append('newfile', this.selecttedFile, this.selecttedFile.name);
    this.http.post<any>(endpoint, formData)
      .subscribe(res => {
        if (res.status = 200) {
          sessionStorage.setItem("imgname", res.message);
          sessionStorage.setItem("imgpath", res.path);
          this.poviewmodel.poImageID = this.poimageid;
          this.poviewmodel.soNo = this.sono;
          this.poviewmodel.imagePath = res.path;
          this.poviewmodel.imageName = res.filename;
          this.os.PutPOImages(this.poviewmodel).subscribe(
            res => {
              this.poviewmodel.imagelist = res.data;
              this.imagecount = res.data.length;
              this.imgno = res.data[this.imagecount - 1].poImageID;
            });
        }
      });
  }

  deleteImage(poimageid, imageName: string) {
    this.poviewmodel.poImageID = poimageid;
    this.os.DeletePOImage(this.poviewmodel).subscribe(
      res => {
        if (res.status == 200) {
          this.poviewmodel.imagelist = res.data;
          this.imagecount = res.data.length;
          if (this.imagecount > 0) {
            this.imgno = res.data[this.imagecount - 1].poImageID;
          }
          this.loadSearch();
          this.router.navigate(['/User/IMGEditor/' + this.sono + '/' + this.img_ob]);
        }
      });
    const endpoint = "Upload/Image/DeleteImage?SONo=" + this.sono + "&FileName=" + imageName;
    this.http.post<any>(endpoint, {}).subscribe(res => {
      console.log(res);
    });

  }

  OBFileInput(event) {
    // if (event.target.files[0].type.includes('spreadsheetml.sheet')) {
    this.selecttedFile = <File>event.target.files[0];
    this.OBUpload();
    // }
    // else {
    //   alert("Invalid Format ! Please choose xlsx File")
    // }
    this.getData();
  }


  OBUpload() {
    const endpoint = 'Upload/Excel/UploadOB/' + this.userID.toString();
    const formData: FormData = new FormData();
    formData.append('file', this.selecttedFile, this.selecttedFile.name);
    this.http.post<any>(endpoint, formData)
      .subscribe(res => {
        if (res.status == 200) {
          // sessionStorage.setItem("pono", this.pono);
          sessionStorage.setItem("sono", this.sono);
          sessionStorage.setItem("obexcelfilename", res.message);
          sessionStorage.setItem("obexcelfilepath", res.path);
          importExcel();
          // this.poviewmodel.poNo = this.pono;
          this.poviewmodel.soNo = this.sono;
          this.getData();
          this.loadSearch();
          if (res.status == 200) {
            this.router.navigate(['/User/IMGEditor/' + this.sono + '/' + this.img_ob]);
          }
        }
      },
        error => {
          console.log(error);
        }
      );

  }
  clickImage(poimageid, poimageName) {
    this.poimageid = poimageid;
    this.poimageName = poimageName;
  }
  // Method to dynamically load JavaScript
  loadScripts() {
    const dynamicScriptsbody = [
      'https://unpkg.com/@ag-grid-enterprise/all-modules@25.1.0/dist/ag-grid-enterprise.min.js',
      'assets/js/w_ob.js',
      'assets/js/custom.js',
      'assets/js/jquery.fancybox.js',
    ];

    for (let i = 0; i < dynamicScriptsbody.length; i++) {
      const node = document.createElement('script');
      node.src = dynamicScriptsbody[i];
      node.type = 'text/javascript';
      node.async = false;
      document.getElementsByTagName('body')[0].appendChild(node);
    }
  }
  changetitle(event: any) {

    var target = event.target || event.srcElement || event.currentTarget;
    var idAttr = target.attributes.id.nodeValue;

    if (idAttr == 'firsttab') {
      this.title = 'imageeditorpo';

    } else {
      this.title = 'obeditorpo';
    }
  }
  cellValueChanged(e: any) {
    this.showSaveButton = true;
    let data = e.data;
    this.OBModel = data;
    const removeIndex = this.updatedRows.findIndex(item => item.OBID == this.OBModel.OBID);
    if (removeIndex != -1) {
      this.updatedRows.splice(removeIndex, 1);
    }
    this.updatedRows.push(this.OBModel);
  }
  async savechanges() {
    var list = this.validateNReturnList();
    if(!list)
      return;

    const postOBs = list && list.length && list[0].OBID > 0 ? false : true;
    if(postOBs) {
      this.os.PostOB(list).subscribe(res => {
        this.dataSaved(res);
      });
    } else {
      this.os.PutOB(list).subscribe(res => {
        this.dataSaved(res);
      });
    }
  }

  private dataSaved(res: any) {
    this.msg.open(res.message, 'info', { duration: 2000 });
    this.getData();
  }

  private validateNReturnList() {
    const arr = [];
    for (let i of this.rowData) {
      arr.push(i.operationCode)
    }

    if (arr.length !== new Set(arr).size) {
      this.msg.open('Duplicate Operation codes are not allowed', 'Error', { duration: 2000 });
      return false;
    }
    var list = [];
    for (let i of this.rowData) {
      var OBList = {
        OBID: i.obid ? parseInt(i.obid) : 0,
        PONo: this.selectedFppo,
        SONo: this.sono,
        SNo: i.sNo,
        OperationCode: i.operationCode,
        OperationName: i.operationName,
        Section: i.section,
        SMV: parseInt(i.smv),
        UserID: i.userID,
        EntryDate: i.entryDate,
        OBLocation: i.obLocation,
        ProcessTypeCode: this.selectedProcessTypeCode,
        ProcessCode: '212',
        FactoryID: parseInt(i.factoryID)
      }
      list.push(OBList);
    };
    return list;
  }

  onPOclick() {
    this.router.navigate(['/User/POView/' + this.sono], { queryParams: { calledFrom: 'ProductionOrder' } });

  }
  productChanged(e: any) {
    this.selectedProductId = e;
    this.existingObs = [];
    if(this.selectedProductId > 0) {
      this.fillExistingOBs();
    }
  }
  OBChanged(e: any) {
    this.selectedExistingOBFileUploadId = e;
    this.rowData = [];
    this.uob.GetOBFileUploadData(this.selectedExistingOBFileUploadId).subscribe(res => {
      this.rowData = res;
      if (this.rowData && this.rowData.length) {
        this.rowData.forEach((e, i) => e.sNo = Number(i + 1));
      }
      if(this.rowData && this.rowData.length) {
        this.savechanges();
      }
    });
  }
  processTypeClicked(e: any) {
    this.selectedProcessTypeCode = e.processType;
    this.fillFPPOs();
  }
  fppoClicked(e: any) {
    this.selectedFppo = e.id;
  }
}

