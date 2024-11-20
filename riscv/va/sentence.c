#include <stdio.h>
#include <string.h>
#define FALSE 0
#define TRUE (!FALSE)


int uppercase(char c)
{
        return (c >= 'A') && (c <= 'Z');
}

int print(char *dir, size_t dlen)
{
        int i;
        for (i = 0; i < dlen; i++) {
                putchar(dir[i]);
        }
        putchar('\n');
        return TRUE;
}

int match_one(char *src, char *pat, size_t len)
{
        return strncmp(src, pat, len) == 0;
}

size_t find_pos(char val, char *instr, size_t ilen)
{
        size_t pos;
        for (pos = 0; pos < ilen; pos++) {
                if (instr[pos] == val)
                        return pos;
        }
        return ilen;
}

int parse_i_add(char *instr, size_t ilen)
{
        char verb[] = "Add";
        char prep_dst[] = ", and put the result into the register";
        size_t pos;
        if (!match_one(instr, verb, sizeof(verb)-1))
                return FALSE;
        pos = find_pos(prep_dst[0], instr, ilen);
        if (pos > ilen - sizeof(prep_dst) + 1)
                return FALSE;
        if (!match_one(instr+pos, prep_dst, sizeof(prep_dst)-1))
                return FALSE;
        return TRUE;
}

int parse_instr(char *instr, size_t ilen)
{
        printf("Instruction: ");
        print(instr, ilen);
        return TRUE;
}

int parse_dir(char *dir, size_t dlen)
{
        printf("Directive: ");
        return print(dir, dlen);
}

int parse_com(char *com, size_t clen)
{
        printf("Comment: ");
        return print(com, clen);
}

static int snum = 1;

int error(char *msg)
{
        fprintf(stderr, "Error: %s at sentence No. %d\n", msg, snum);
        return FALSE;
}

char dir_prompt[] = "To assembler: ";
#define DPS (sizeof(dir_prompt) - 1)
int parse_sentence(char *sen, size_t slen)
{
        if (slen<1)
                return error("Empty sentence");
        switch (sen[slen-1]) {
                case '.':
                        if (uppercase(sen[0]))
                                return parse_instr(sen, slen-1);
                        return error("First char must be in uppercase");
                case ')':
                        if (slen < 2)
                                return error("wtf");
                        if ((sen[0] == '(') && (sen[slen-2] == '.')) {
                                if (slen-DPS-3<0)
                                        return error("wtf");
                                if (strncmp(sen+1, dir_prompt, DPS) == 0)
                                        return parse_dir(sen+DPS+1, slen-DPS-3);
                                else
                                        return parse_com(sen + 1, slen - 3);
                        }
                        return error("Unmatched ( or no period");
        }
        return error("Unknown error");
}

#define PS(s) parse_sentence(s, sizeof(s)-1)
int main(void)
{
        char s1[] = "Add two numbers.";
        char s2[] = "(To assembler: emit the C runtime section.)";
        char s3[] = "(Useless comment.)";
        PS(s1);
        PS(s2);
        PS(s3);
        return 0;
}
