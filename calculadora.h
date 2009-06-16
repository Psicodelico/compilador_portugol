#define MAX_TS 100;

typedef enum
{
    tipoIndef,
    tipoInt,
    tipoFloat
} tipoDado;

typedef struct tabelaSimb
{
    tipoDado tipo;
    float val;
} tabelaSimb;

tabelaSimb ts[MAX_TS];
tabelaSimb *nova_ts();
void init_ts();

tabelaSimb *nova_ts() {
    tabelaSimb *ts = (tabelaSimb *) malloc(sizeof(tabelaSimb));
    return ts;
}

void init_ts() {
    int i;
    for(i = 0; i < MAX_TS; i++)
        ts[i].tipo = tipoIndef;
}
