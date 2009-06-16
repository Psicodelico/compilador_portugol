#define MAX_TS 100



typedef enum
{
    tipoIndef,
    tipoInt,
    tipoFloat
} tipoDado;

typedef struct
{
    tipoDado tipo;
    int id;
    float val;
} tabelaSimb;

tabelaSimb ts[MAX_TS];
tabelaSimb *nova_ts();
void init_ts();


