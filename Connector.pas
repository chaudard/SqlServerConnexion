unit Connector;

interface

type TConnector = class
  private
    FDataSource: string;
    FCatalog: string;
    FTableName: string;
    FbUserPassword: boolean;
    FUser: string;
    FPassword: string;

    procedure setDataSource(const aDataSource: string);
    function  getDataSource: string;
    procedure setCatalog(const aCatalog: string);
    function  getCatalog: string;
    procedure setTableName(const aTableName: string);
    function  getTableName: string;
    procedure setbUserPassword(const abUserPassword: boolean);
    function  getbUserPassword: boolean;
    procedure setUser(const aUser: string);
    function  getUser: string;
    procedure setPassword(const aPassword: string);
    function  getPassword: string;
  published
    property dataSource: string read getDataSource write setDataSource;
    property catalog: string read getCatalog write setCatalog;
    property tableName: string read getTableName write setTableName;
    property bUserPassword: boolean read getbUserPassword write setbUserPassword;
    property user: string read getUser write setUser;
    property password: string read getPassword write setPassword;
{
  private
}
  public
    constructor Create; overload;
    constructor Create(const aDataSource: string;
                       const aCatalog: string;
                       const aTableName: string;
                       const abUserPassword: boolean;
                       const aUser: string;
                       const aPassword: string); overload;
    destructor  Destroy; override;

end;

implementation

{ TConnector }

constructor TConnector.Create;
begin
  inherited Create;
  dataSource := '';
  catalog := '';
  tableName := '';
  bUserPassword := false;
  user := '';
  password := '';
end;

constructor TConnector.Create(const aDataSource, aCatalog, aTableName: string;
  const abUserPassword: boolean; const aUser, aPassword: string);
begin
  inherited Create;
  dataSource := aDataSource;
  catalog := aCatalog;
  tableName := aTableName;
  bUserPassword := abUserPassword;
  user := aUser;
  password := aPassword;
end;

destructor TConnector.Destroy;
begin
  inherited Destroy;
end;

function TConnector.getbUserPassword: boolean;
begin
  result := FbUserPassword;
end;

function TConnector.getCatalog: string;
begin
  result := FCatalog;
end;

function TConnector.getDataSource: string;
begin
  result := FDataSource;
end;

function TConnector.getPassword: string;
begin
  result := FPassword;
end;

function TConnector.getTableName: string;
begin
  result := FTableName;
end;

function TConnector.getUser: string;
begin
  result := FUser;
end;

procedure TConnector.setbUserPassword(const abUserPassword: boolean);
begin
  FbUserPassword := abUserPassword;
end;

procedure TConnector.setCatalog(const aCatalog: string);
begin
  FCatalog := aCatalog;
end;

procedure TConnector.setDataSource(const aDataSource: string);
begin
  FDataSource := aDataSource;
end;

procedure TConnector.setPassword(const aPassword: string);
begin
  FPassword := aPassword;
end;

procedure TConnector.setTableName(const aTableName: string);
begin
  FTableName := aTableName;
end;

procedure TConnector.setUser(const aUser: string);
begin
  FUser := aUser;
end;

end.
